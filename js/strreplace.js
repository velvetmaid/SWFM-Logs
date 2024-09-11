    let str = '123456789012'

    str = str.replace(/[^0-9]/g, '');

    switch (true) {
        case (str.length > 12):
            str = str.substring(0, 12);
            console.log("g>");
        break;
        case (str.length < 12):
            console.log(false);
        break;
        case (str.length === 12):
            console.log(true)
        break;
    }

    console.log(str)