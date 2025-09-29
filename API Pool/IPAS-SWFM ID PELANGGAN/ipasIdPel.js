const https = require("https");
const axios = require("axios");
const { performance } = require("perf_hooks");
const { poolSWFM } = require("./config");

const httpsAgent = new https.Agent({ rejectUnauthorized: false });

const col = [
  "idpel",
  "pelname",
  "goltarif",
  "daya",
  "billtype",
  "plafond",
  "siteid",
  "sitename",
  "regional",
  "statussite",
  "tower",
  "statusidpel",
  "tx_request_powerid",
  "tm_powerid",
  "area",
  "billresponsibility",
  "siteowner",
];

const apiToDbMapping = {
  IdPel: "idpel",
  PelName: "pelname",
  GolTarif: "goltarif",
  Daya: "daya",
  BillType: "billtype",
  Plafond: "plafond",
  SiteId: "siteid",
  SiteName: "sitename",
  Regional: "regional",
  StatusSite: "statussite",
  Tower: "tower",
  StatusIdPel: "statusidpel",
  Tx_Request_PowerId: "tx_request_powerid",
  Tm_PowerId: "tm_powerid",
  Area: "area",
  BillResponsibility: "billresponsibility",
  SiteOwner: "siteowner",
};

const data = {
  Tm_RegionalId: "",
  Tm_AreaId: null,
  Tm_NSAId: null,
  Tm_RTPOId: null,
  Tm_Request_StatusId: "",
  BillTypeId: "",
  siteownershipID: "",
  StartIndex: 0,
  MaxRecordDropdown: 1000000,
  SerchIdPel: "",
  TowerProviderId: "",
  SearchSiteID: "",
  BillResponsibilityId: "",
};

const mapApiRowToDb = (row) => {
  const mapped = {};
  for (const [apiKey, dbKey] of Object.entries(apiToDbMapping)) {
    mapped[dbKey] = row[apiKey] ?? null;
  }
  return mapped;
};

(async () => {
  const clientA = await poolSWFM();
  try {
    const startA = performance.now();
    const response = await axios.post(
      "https://ipas.network.telkomsel.co.id/IPAS_API_POWER/rest/API_Anomaly_Outlier/ListIDPelActive",
      data,
      { httpsAgent }
    );
    const endA = performance.now();
    const rows = response.data;

    if (!rows.length) {
      console.log("⚠️ No data received from API.");
      return;
    }

    console.log(`✅ API executed in ${Math.round(endA - startA)} ms`);
    console.log(`📦 Total records: ${rows.length}`);

    const numParams = col.length;
    const placeholders = Array.from(
      { length: numParams },
      (_, i) => `$${i + 1}`
    ).join(", ");

    const insertOrUpdateQuery = `
      INSERT INTO wfm_schema.tm_power_pln_pelanggan_ipas (${col.join(", ")})
      VALUES (${placeholders})
      ON CONFLICT (tm_powerid)
      DO UPDATE SET ${col
        .filter((c) => c !== "tm_powerid")
        .map((c) => `${c} = EXCLUDED.${c}`)
        .join(", ")};
    `;

    const BATCH_SIZE = 100;
    const startB = performance.now();

    for (let i = 0; i < rows.length; i += BATCH_SIZE) {
      const batch = rows.slice(i, i + BATCH_SIZE);

      await Promise.all(
        batch.map(async (row) => {
          const mapped = mapApiRowToDb(row);
          const params = col.map((c) => mapped[c]);
          await clientA.query(insertOrUpdateQuery, params);
        })
      );

      console.log(
        `✅ Inserted batch ${Math.ceil(i / BATCH_SIZE) + 1}/${Math.ceil(
          rows.length / BATCH_SIZE
        )}`
      );
    }

    const endB = performance.now();
    console.log(`🚀 All data processed in ${Math.round(endB - startB)} ms`);
    console.log("🎉 Data seed complete!");
  } catch (error) {
    console.error("🔥 Error:", error.message);
    console.error(error.stack);
  } finally {
    await clientA.end();
  }
})();
