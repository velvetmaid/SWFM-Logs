WITH RankedAbsences AS (
    SELECT
        -- * COUNT(*) AS total_absences,
        userid,
        absentype
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate
        ) AS RankAsc,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate DESC
        ) AS RankDesc
    FROM
        wfm_schema.tx_absen
    GROUP BY
        userid,
        absendate,
        absentype
),
TicketInfo AS (
    SELECT
        pic_id,
        COUNT(
            CASE
                WHEN status = 'IN PROGRESS' THEN 1
            END
        ) AS tiket_in_progress,
        COUNT(
            CASE
                WHEN status = 'ASSIGNED' THEN 1
            END
        ) AS tiket_assigned,
        COUNT(
            CASE
                WHEN status = 'CLOSED' THEN 1
            END
        ) AS tiket_closed,
        COUNT(
            CASE
                WHEN status NOT IN ('IN PROGESS', 'ASSIGNED', 'CLOSED') THEN 1
            END
        ) AS tiket_lainnya
    FROM
        wfm_schema.tx_ticket_terr_opr
    GROUP BY
        pic_id
)
SELECT
    ra.userid,
    -- ra.total_absences,
    ti.tiket_in_progress,
    ti.tiket_assigned,
    ti.tiket_closed,
    ti.tiket_lainnya
FROM
    RankedAbsences ra
    LEFT JOIN TicketInfo ti ON ra.userid :: VARCHAR = ti.pic_id
WHERE
    (
        ra.RankAsc = 1
        AND ra.absentype = true
    )
    OR (
        ra.RankDesc = 1
        AND ra.absentype = false
    );

-- end ef
-- end ef
-- end ef
WITH RankedAbsences AS (
    SELECT
        userid,
        absendate,
        absentype,
        COUNT(*) AS total_absences,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate
        ) AS RankAsc,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate DESC
        ) AS RankDesc
    FROM
        wfm_schema.tx_absen
    GROUP BY
        userid,
        absendate,
        absentype
),
TicketInfo AS (
    SELECT
        pic_id
    FROM
        wfm_schema.tx_ticket_terr_opr
    GROUP BY
        pic_id
)
SELECT
    ra.userid
FROM
    RankedAbsences ra
    LEFT JOIN TicketInfo ti ON ra.userid :: VARCHAR = ti.pic_id
WHERE
    ra.RankAsc = 1
    AND ra.absentype = true;

-- 
-- 
-- 
WITH RankedAbsences AS (
    SELECT
        userid,
        absentype,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate
        ) AS RankAsc,
        ROW_NUMBER() OVER (
            PARTITION BY userid,
            absendate
            ORDER BY
                absendate DESC
        ) AS RankDesc
    FROM
        wfm_schema.tx_absen
    GROUP BY
        userid,
        absendate,
        absentype
    ORDER BY
        userid ASC,
        absendate ASC
)
SELECT
    *
FROM
    RankedAbsences
WHERE
    RankAsc = 1
    AND absentype = true;