const { poolSWFM, poolNDM } = require("./config");
const { performance } = require("perf_hooks");
const fs = require("fs");
const path = require("path");

(async () => {
  const clientA = await poolSWFM();
  const clientB = await poolNDM();

  try {
    const startA = performance.now();

    const fnaQueriesPath = path.join(
      __dirname,
      "./queries/read_fna_ticket.sql"
    );

    const SelectFNAQueries = fs.readFileSync(fnaQueriesPath, "utf8");
    // const SelectFNAQueries = `
    //   SELECT
    //     ticket_technical_support_id AS tx_field_operation_non_alarm_id,
    //     no_ticket,
    //     site_id,
    //     cluster_area,
    //     category,
    //     ticket_subject,
    //     job_details,
    //     job_targets,
    //     sla_start,
    //     sla_end,
    //     sla_range,
    //     created_by,
    //     created_at,
    //     modified_by,
    //     modified_at,
    //     activity_name,
    //     role_name,
    //     respone_time,
    //     submit_time,
    //     user_submitter,
    //     approve_time,
    //     user_approve,
    //     note,
    //     review,
    //     status,
    //     rootcause1,
    //     rootcause2,
    //     rootcause3,
    //     rootcause_remark,
    //     resolution_action,
    //     pic_id,
    //     pic_name,
    //     description,
    //     "name",
    //     issue_category,
    //     is_asset_change,
    //     take_over_at,
    //     checkin_at,
    //     follow_up_at,
    //     request_permit_at,
    //     is_exclude
    //   FROM wfm_schema.ticket_technical_support
    // `;

    const resultA = await clientA.query(SelectFNAQueries);
    const endA = performance.now();
    console.log(`Select FNA queries executed in ${Math.round(endA - startA)} ms`);

    const startB = performance.now();

    const insertOrUpdateFNA = `
      INSERT INTO wfm_schema.tx_field_operation_non_alarm (
        tx_field_operation_non_alarm_id,
        ticket_no,
        site_id,
        cluster_area,
        category,
        ticket_subject,
        job_details,
        job_targets,
        sla_start,
        sla_end,
        sla_range,
        created_by,
        created_at,
        modified_by,
        modified_at,
        activity_name,
        role_name,
        respone_time,
        submit_time,
        user_submitter,
        approve_time,
        user_approve,
        note,
        review,
        status,
        rootcause1,
        rootcause2,
        rootcause3,
        rootcause_remark,
        resolution_action,
        pic_id,
        pic_name,
        description,
        "name",
        issue_category,
        is_asset_change,
        take_over_at,
        checkin_at,
        follow_up_at,
        request_permit_at,
        is_exclude
      )
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41
      )
      ON CONFLICT (tx_field_operation_non_alarm_id)
      DO UPDATE SET
        ticket_no = EXCLUDED.ticket_no,
        site_id = EXCLUDED.site_id,
        cluster_area = EXCLUDED.cluster_area,
        category = EXCLUDED.category,
        ticket_subject = EXCLUDED.ticket_subject,
        job_details = EXCLUDED.job_details,
        job_targets = EXCLUDED.job_targets,
        sla_start = EXCLUDED.sla_start,
        sla_end = EXCLUDED.sla_end,
        sla_range = EXCLUDED.sla_range,
        created_by = EXCLUDED.created_by,
        created_at = EXCLUDED.created_at,
        modified_by = EXCLUDED.modified_by,
        modified_at = EXCLUDED.modified_at,
        activity_name = EXCLUDED.activity_name,
        role_name = EXCLUDED.role_name,
        respone_time = EXCLUDED.respone_time,
        submit_time = EXCLUDED.submit_time,
        user_submitter = EXCLUDED.user_submitter,
        approve_time = EXCLUDED.approve_time,
        user_approve = EXCLUDED.user_approve,
        note = EXCLUDED.note,
        review = EXCLUDED.review,
        status = EXCLUDED.status,
        rootcause1 = EXCLUDED.rootcause1,
        rootcause2 = EXCLUDED.rootcause2,
        rootcause3 = EXCLUDED.rootcause3,
        rootcause_remark = EXCLUDED.rootcause_remark,
        resolution_action = EXCLUDED.resolution_action,
        pic_id = EXCLUDED.pic_id,
        pic_name = EXCLUDED.pic_name,
        description = EXCLUDED.description,
        "name" = EXCLUDED."name",
        issue_category = EXCLUDED.issue_category,
        is_asset_change = EXCLUDED.is_asset_change,
        take_over_at = EXCLUDED.take_over_at,
        checkin_at = EXCLUDED.checkin_at,
        follow_up_at = EXCLUDED.follow_up_at,
        request_permit_at = EXCLUDED.request_permit_at,
        is_exclude = EXCLUDED.is_exclude
    `;

    for (const row of resultA.rows) {
      const params = [
        row.tx_field_operation_non_alarm_id,
        row.no_ticket,
        row.site_id,
        row.cluster_area,
        row.category,
        row.ticket_subject,
        row.job_details,
        row.job_targets,
        row.sla_start,
        row.sla_end,
        row.sla_range,
        row.created_by,
        row.created_at,
        row.modified_by,
        row.modified_at,
        row.activity_name,
        row.role_name,
        row.respone_time,
        row.submit_time,
        row.user_submitter,
        row.approve_time,
        row.user_approve,
        row.note,
        row.review,
        row.status,
        row.rootcause1,
        row.rootcause2,
        row.rootcause3,
        row.rootcause_remark,
        row.resolution_action,
        row.pic_id,
        row.pic_name,
        row.description,
        row.name,
        row.issue_category,
        row.is_asset_change,
        row.take_over_at,
        row.checkin_at,
        row.follow_up_at,
        row.request_permit_at,
        row.is_exclude,
      ];
      await clientB.query(insertOrUpdateFNA, params);
    }

    const endB = performance.now();
    console.log(
      `Insert/Update FNA queries executed in ${Math.round(endB - startB)} ms`
    );

    console.log("Data seed successfully!");
  } catch (err) {
    console.error("Error during data seed:", err.stack);
  } finally {
    await clientA.end();
    await clientB.end();
  }
})();
