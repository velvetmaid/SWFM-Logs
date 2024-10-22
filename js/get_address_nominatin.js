async function getAddress() {
    var latitude = document.getElementById($parameters.latId).value;
    var longitude = document.getElementById($parameters.longId).value;

    console.log(latitude + "," + longitude);

    if (latitude && longitude) {
        var url = "https://nominatim.openstreetmap.org/reverse?lat=" + latitude + "&lon=" + longitude + "&format=json";
        console.log(url);

        try {
            const response = await fetch(url);
            const data = await response.json();
            console.log(data);

            if (data && data.address) {
                var address = (data.address.road || '') + ', ' + (data.address.city || '') + ', ' + (data.address.country || '');
                $parameters.outaddress = address; 
                console.log("Updated outaddress:", $parameters.outaddress); 

                document.getElementById($parameters.addressId).value = address;

                useUpdatedAddress($parameters.outaddress);
            } else {
                alert('Address not found for the given coordinates.');
            }
        } catch (error) {
            console.error('Error fetching the address:', error);
        }
    } 
}

function useUpdatedAddress(address) {
    console.log("Using updated address:", address);
}

getAddress();
