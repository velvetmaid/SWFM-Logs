const jsonString = $parameters.JSON; 
const jsonData = JSON.parse(jsonString); 

const wrapperTable = document.getElementById('WrapperTable');
const h1 = document.createElement('h1');
h1.textContent = 'Hello World';
wrapperTable.appendChild(h1);

const table = document.createElement('table');
table.border = "1"; 

const headerRow = document.createElement('tr');

const keys = Object.keys(jsonData.Data[0]).filter(key => key !== 'Id');

headerRow.appendChild(document.createElement('th')).textContent = 'No'; 

keys.forEach(key => {
    const th = document.createElement('th');
    th.textContent = key; 
    headerRow.appendChild(th);
});
table.appendChild(headerRow); 

jsonData.Data.forEach((item, index) => {
    const row = document.createElement('tr'); 
    const orderCell = document.createElement('td');
    orderCell.textContent = index + 1; 
    row.appendChild(orderCell);
    
    keys.forEach(key => {
        const td = document.createElement('td');
        td.textContent = item[key]; 
        row.appendChild(td);
    });
    table.appendChild(row); 
});

wrapperTable.appendChild(table);