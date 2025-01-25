--You want to find the most recent errors for from the containers:
SELECT
    TIMESTAMP,
    JSON_VALUE (resource.labels.container_name) AS container,
    json_payload
FROM
    `qwiklabs-gcp-00-d47c06b6a1f9.global.day2ops-log._AllLogs`
WHERE
    severity = "ERROR"
    AND json_payload IS NOT NULL
ORDER BY
    1 DESC
LIMIT
    50;

--You can view the min, max, and average latencies in a timeframe for the frontend service:
SELECT
    hour,
    MIN(took_ms) AS min,
    MAX(took_ms) AS max,
    AVG(took_ms) AS avg
FROM
    (
        SELECT
            FORMAT_TIMESTAMP ("%H", timestamp) AS hour,
            CAST(
                JSON_VALUE (json_payload, '$."http.resp.took_ms"') AS INT64
            ) AS took_ms
        FROM
            `qwiklabs-gcp-00-d47c06b6a1f9.global.day2ops-log._AllLogs`
        WHERE
            timestamp > TIMESTAMP_SUB (CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
            AND json_payload IS NOT NULL
            AND SEARCH (labels, "frontend")
            AND JSON_VALUE (json_payload.message) = "request complete"
        ORDER BY
            took_ms DESC,
            timestamp ASC
    )
GROUP BY
    1
ORDER BY
    1;

--You want to know how many times users visit a certain product page in the past hour:
SELECT
    count(*)
FROM
    `qwiklabs-gcp-00-d47c06b6a1f9.global.day2ops-log._AllLogs`
WHERE
    text_payload like "GET %/product/L9ECAV7KIM %"
    AND timestamp > TIMESTAMP_SUB (CURRENT_TIMESTAMP(), INTERVAL 1 HOUR);

--You can run the following query to view how many sessions end up with checkout (POST call to the /cart/checkout service):
SELECT
 JSON_VALUE(json_payload.session),
 COUNT(*)
FROM
 `qwiklabs-gcp-00-d47c06b6a1f9.global.day2ops-log._AllLogs`
WHERE
 JSON_VALUE(json_payload['http.req.method']) = "POST"
 AND JSON_VALUE(json_payload['http.req.path']) = "/cart/checkout"
 AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY
 JSON_VALUE(json_payload.session);
