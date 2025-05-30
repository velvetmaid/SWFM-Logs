const data = {
  "select * from wfm_schema.tx_cmsite_header tch \r\nwhere ticket_no = 'SVA-2025-000000002344'\r\nlimit 10":
    [
      {
        cmsite_id: 15540,
        ticket_no: "SVA-2025-000000002344",
        site_id: "TJS194",
        cm_type: "POWER",
        cm_urgency: "LOW",
        cm_assetphysical_group: "|GENSET|",
        issue_category:
          "Transportasi Air PM Genset TJS194 REPEATERGUNUNGDAENG Tahap 1 & Tahap 2 Maret 2025",
        issue_explanation:
          "Transportasi Air PM Genset TJS194 REPEATERGUNUNGDAENG Tahap 1 & Tahap 2 Maret 2025",
        maintenance_treshold: "",
        recommendation:
          "Transportasi Air PM Genset TJS194 REPEATERGUNUNGDAENG Tahap 1 & Tahap 2 Maret 2025",
        asset_change: false,
        status: "CLOSED",
        draft_approve_by: 1961,
        draft_approve_date: "2025-03-20T02:31:00.000Z",
        created_by: "63387",
        created_at: "2025-03-19T05:37:47.000Z",
        modified_by: "1961",
        modified_at: "2025-04-07T13:20:19.000Z",
        deleted_by: "",
        deleted_at: "1899-12-31T17:00:00.000Z",
        is_active: true,
        is_delete: false,
        tm_resolution_id: "",
        pic_id: "2669",
        pic_name: "Arizona Rosadi",
        rootcause1: "",
        rootcause2: "",
        rootcause3: "",
        rootcause_remarks: "",
        urgency: "",
        notes: "",
        resolution_action: "",
        foto_preparation: "",
        foto_preparation_name: "",
        foto_preparation_location: "",
        foto_before1: "",
        foto_before1_name: "",
        foto_before1_location: "",
        foto_before2: "",
        foto_before2_name: "",
        foto_before2_location: "",
        foto_before3: "",
        foto_before3_name: "",
        foto_before3_location: "",
        foto_before4: "",
        foto_before4_name: "",
        foto_before4_location: "",
        foto_after1: "",
        foto_after1_name: "",
        foto_after1_location: "",
        foto_after2: "",
        foto_after2_name: "",
        foto_after2_location: "",
        foto_after3: "",
        foto_after3_name: "",
        foto_after3_location: "",
        foto_after4: "",
        foto_after4_name: "",
        foto_after4_location: "",
        ticket_priority: 6,
        site_before: "",
        site_before_name: "",
        site_before_location: "a2bed0ef-3ec3-40f2-98ba-b64fa6ff8541",
        problem: "",
        problem_name: "",
        problem_location: "410bf108-7039-4048-b18d-4edbbd931f78",
        new_part: "",
        new_part_name: "",
        new_part_location: "603dacb5-e3ec-45b2-a3b7-13fb2a022617",
        activity1: "",
        activity1_name: "",
        activity1_location: "a2f59572-7e7d-44b9-a432-e84456efa3ef",
        activity2: "",
        activity2_name: "",
        activity2_location: "e92ccda1-d855-45f6-b39a-75aaa607153e",
        activity3: "",
        activity3_name: "",
        activity3_location: "d86ac25f-026e-47e0-b613-dbd05e5b4e01",
        activity4: "",
        activity4_name: "",
        activity4_location: "61382fde-2558-4878-a479-15aeb15d3c14",
        activity5: "",
        activity5_name: "",
        activity5_location: "9ffef8f5-4c36-4cf2-89e9-dd3a907b88a5",
        broken_part: "",
        broken_part_name: "",
        broken_part_location: "1d3a97ec-1cee-4c03-8959-ba3225a249b2",
        solution: "",
        solution_name: "",
        solution_location: "821ad0cb-271a-4d7f-9fae-9867c7509c2a",
        site_after: "",
        site_after_name: "",
        site_after_location: "0cdab427-a153-4c37-bcf8-604081036961",
        final_result: "",
        final_result_name: "",
        final_result_location: "9d326edb-417d-494e-9f5e-9d48f00b7668",
        replaced_item: "",
        replaced_item_name: "",
        replaced_item_location: "0379b9d3-9192-4338-9242-1d4ab7622d3d",
        submiter_id: "2669",
        submiter_name: "ARIZONA ROSADI",
        draft_status: "READY FOR FMS",
        submit_date: "2025-04-04T08:55:50.000Z",
        creator_name: "Arizona Rosadi",
        is_revised: false,
        take_over_at: "2025-03-22T05:01:41.541Z",
        checkin_at: "2025-04-04T08:45:56.000Z",
        service_layer: "L0",
        ready_for_fms_time: "2025-03-20T02:31:00.000Z",
        follow_up_at: "1899-12-31T17:00:00.000Z",
        request_permit_at: "1899-12-31T17:00:00.000Z",
        closed_at: "2025-04-07T13:20:19.000Z",
        ioms_operation_id: "",
        activity_approval_status: "",
        activity_approved_by: "",
        activity_approved_at: "1899-12-31T17:00:00.000Z",
        spv_approver_name: "",
        approver_email: "",
        vendor_code: "",
        vendor_name: "",
        area_id: "Area4",
        regional_id: "R08",
        nop_id: "NOP63",
        cluster_id: 439,
        condition_asset: "",
        tgl_kejadian: "1899-12-31T17:00:00.000Z",
        is_exclude: null,
      },
    ],
};

const formatTime = (minutes) => {
  const days = Math.floor(minutes / (60 * 24));
  const hours = Math.floor((minutes % (60 * 24)) / 60);
  const mins = minutes % 60;

  return `${minutes}m (${days}d ${hours}h ${mins}m)`;
};

const calculateSLA = (ticket) => {
  const urgency = ticket.cm_urgency;
  const draftApprove = new Date(ticket.draft_approve_date);
  const readyForFms = new Date(ticket.ready_for_fms_time);
  const closedAt = new Date(ticket.closed_at);

  const slaParam = urgency === "HIGH" ? 48 * 60 : 30 * 24 * 60;
  const slaEnd = new Date(readyForFms.getTime() + slaParam * 60000);

  const isClosed = !isNaN(closedAt) && closedAt > draftApprove;
  const endTime = isClosed ? closedAt : new Date();
  const mttr = isClosed ? Math.floor((endTime - draftApprove) / 60000) : null;

  const inSLA = mttr !== null ? mttr <= slaParam : false;
  const status = inSLA ? "IN SLA" : "OUT SLA";

  const explanation = isClosed
    ? inSLA
      ? `MTTR ${formatTime(mttr)} masih di bawah SLA ${formatTime(slaParam)}`
      : `MTTR ${formatTime(mttr)} melewati SLA ${formatTime(slaParam)}`
    : `Ticket belum ditutup, MTTR belum bisa dihitung.`;

  const explanationDetails = {
    slaReason:
      urgency === "HIGH"
        ? "SLA didapat dari urgensi HIGH → 48 jam = 2880 menit"
        : "SLA didapat dari urgensi LOW → 30 hari × 24 jam = 43200 menit",
    mttrReason: isClosed
      ? `MTTR didapat dari selisih waktu Closed At (${closedAt
          .toISOString()
          .replace("T", " ")
          .substring(0, 19)}) dan Draft Approve Date (${draftApprove
          .toISOString()
          .replace("T", " ")
          .substring(0, 19)})`
      : `MTTR belum bisa dihitung karena tiket belum ditutup.`,
  };

  return {
    ticket_no: ticket.ticket_no,
    urgency,
    draftApprove,
    readyForFms,
    closedAt: isClosed ? closedAt : null,
    slaParam,
    slaFormatted: formatTime(slaParam),
    slaEnd,
    mttr,
    mttrFormatted: mttr !== null ? formatTime(mttr) : "-",
    status,
    explanation,
    explanationDetails,
  };
};

const tickets = Object.values(data)[0];

const filteredTickets = tickets.filter((ticket) => {
  const status = ticket.status;
  const draftStatus = ticket.draft_status;

  return (
    status !== "WAITING ACTIVITY APPROVAL" &&
    status !== "CANCELED" &&
    draftStatus === "READY FOR FMS"
  );
});

filteredTickets.map(calculateSLA).forEach((result) => {
  console.log(`
  📋 Ticket Summary
  ━━━━━━━━━━━━━━━━━━━━━
  🎟️ Ticket No: ${result.ticket_no}
  ⚡ Urgency: ${result.urgency}
  📝 Draft Approve Date: ${result.draftApprove
    .toISOString()
    .replace("T", " ")
    .substring(0, 19)}
  🛠️ Ready for FMS: ${result.readyForFms
    .toISOString()
    .replace("T", " ")
    .substring(0, 19)}
  🛑 Closed At: ${
    result.closedAt
      ? result.closedAt.toISOString().replace("T", " ").substring(0, 19)
      : "❌ Belum ditutup"
  }
  
  🕓 SLA:
  
  Minutes: ${result.slaParam}
  Formatted: ${result.slaFormatted}
  SLA End: ${result.slaEnd.toISOString().replace("T", " ").substring(0, 19)}
  📖 ${result.explanationDetails.slaReason}
  
  🛠️ MTTR:
  
  Minutes: ${result.mttr !== null ? result.mttr : "-"}
  Formatted: ${result.mttrFormatted}
  📖 ${result.explanationDetails.mttrReason}
  
  📌 Status: ${result.status}
  💬 ${result.explanation}
  
  ━━━━━━━━━━━━━━━━━━━━━
  `);
});
