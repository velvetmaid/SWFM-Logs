const axios = require("axios");
const { performance } = require("perf_hooks");
const column = require("./tm_power_pelanggan_pln_ipas.json");

const data = {
  Tm_RegionalId: "",
  Tm_AreaId: null,
  Tm_NSAId: null,
  Tm_RTPOId: null,
  Tm_Request_StatusId: "",
  BillTypeId: "",
  siteownershipID: "",
  StartIndex: 0,
  MaxRecordDropdown: 2,
  SerchIdPel: "",
  TowerProviderId: "",
  SearchSiteID: "",
  BillResponsibilityId: "",
};

async function fetchData() {
  try {
    const startA = performance.now();
    const response = await axios.post(
      "https://ipas.network.telkomsel.co.id/IPAS_API_POWER/rest/API_Anomaly_Outlier/ListIDPelActive",
      data
    );
    const endA = performance.now();
    console.log(response.data);
    console.log(`Executed in ${Math.round(endA - startA)} ms`);
  } catch (error) {
    console.log(error);
  }
}
fetchData();
