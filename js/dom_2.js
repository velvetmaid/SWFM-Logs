const jsonString = $parameters.JSON;
const jsonData = JSON.parse(jsonString);
const wrapperTable = document.getElementById("WrapperTable");

const h1 = document.createElement('h1');
h1.textContent = 'Use DOM';
wrapperTable.appendChild(h1);

const table = document.createElement("table");
table.className = "table";

const thead = document.createElement("thead");
const headerRow = document.createElement("tr");
headerRow.className = "table-header";

const thNo = document.createElement("th");
thNo.textContent = "No";
headerRow.appendChild(thNo);

const keys = Object.keys(jsonData.Data[0]).filter((key) => key !== "Id");

keys.forEach((key) => {
  const th = document.createElement("th");
  th.textContent = key;
  headerRow.appendChild(th);
});
thead.appendChild(headerRow);
table.appendChild(thead);

const tbody = document.createElement("tbody");

jsonData.Data.forEach((item, index) => {
  const row = document.createElement("tr");
  row.className = "table-row";

  const orderCell = document.createElement("td");
  orderCell.textContent = index + 1;
  row.appendChild(orderCell);

  keys.forEach((key) => {
    const td = document.createElement("td");
    td.textContent = item[key];
    row.appendChild(td);
  });

  tbody.appendChild(row);
});

table.appendChild(tbody);
wrapperTable.appendChild(table);