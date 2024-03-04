CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absent_location_rank AS WITH RankedAbsences AS (
WITH RankedAbsences AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absentime
        ) AS RankAsc,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absentime DESC
        ) AS RankDesc
    FROM
        wfm_schema.tx_absen
    ORDER BY
        userid ASC,
        absentime ASC
)
SELECT
    *
FROM
    RankedAbsences
WHERE
    RankAsc = 1
    AND absentype = true
    OR RankDesc = 1
    AND absentype = false;
-- 
-- 
-- 
WITH RankedAbsences AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absentime
        ) AS RankAsc,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absentime DESC
        ) AS RankDesc
    FROM
        wfm_schema.tx_absen
),
FilteredAbsences AS (
    SELECT
        userid
    FROM
        RankedAbsences
    WHERE
        (
            RankAsc = 1
            AND absentype = true
        )
        OR (
            RankDesc = 1
            AND absentype = false
        )
)
SELECT
    f.userid,
    COUNT(
        CASE
            WHEN t.status = 'IN PROGRESS' THEN 1
        END
    ) AS jumlah_in_progress,
    COUNT(
        CASE
            WHEN t.status = 'ASSIGNED' THEN 1
        END
    ) AS jumlah_assigned,
    COUNT(
        CASE
            WHEN t.status = 'RESOLVED' THEN 1
        END
    ) AS jumlah_resolved,
    COUNT(
        CASE
            WHEN t.status = 'CLOSED' THEN 1
        END
    ) AS jumlah_closed
FROM
    FilteredAbsences f
    LEFT JOIN wfm_schema.tx_ticket_terr_opr t ON f.userid :: VARCHAR = t.pic_id
GROUP BY
    f.userid;