const axios = require("axios");
const { performance } = require("perf_hooks");
const { poolSWFM } = require("./config");

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
  "siteowner"
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
  SiteOwner: "siteowner"
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
  MaxRecordDropdown: 10,
  SerchIdPel: "",
  TowerProviderId: "",
  SearchSiteID: "",
  BillResponsibilityId: "",
};

(async () => {
  const clientA = await poolSWFM();
  try {
    const startA = performance.now();
    const response = await axios.post(
      "https://ipas.network.telkomsel.co.id/IPAS_API_POWER/rest/API_Anomaly_Outlier/ListIDPelActive",
      data
    );
    const endA = performance.now();
    const resultA = response.data;

    console.log("API Response:", JSON.stringify(resultA, null, 2));

    const rows = resultA;

    if (rows.length === 0) {
      console.log("No data received from API.");
      return;
    }

    console.log(`Executed in ${Math.round(endA - startA)} ms`);

    const numParams = col.length;
    const placeholders = Array.from(
      { length: numParams },
      (_, i) => `$${i + 1}`
    ).join(", ");

    const insertOrUpdateFNA = `
      INSERT INTO wfm_schema.tm_power_pln_pelanggan_ipas (${col.join(", ")})
      VALUES (${placeholders})
      ON CONFLICT (tm_powerid)
      DO UPDATE SET ${col
        .map((col) => `${col} = EXCLUDED.${col}`)
        .join(", ")};
    `;

    const startB = performance.now();
    for (const row of rows) {
      const params = col.map((col) => row[Object.keys(apiToDbMapping).find(key => apiToDbMapping[key] === col)]);

      console.log("Executing query with params:", params);
      const result = await clientA.query(insertOrUpdateFNA, params);
      console.log("Query result:", result);
    }
    const endB = performance.now();
    console.log(
      `Insert/Update Power PLN IPAS queries executed in ${Math.round(
        endB - startB
      )} ms`
    );

    console.log("Data seed successfully!");
  } catch (error) {
    console.log("Error:", error);
  } finally {
    await clientA.end();
  }
})();
