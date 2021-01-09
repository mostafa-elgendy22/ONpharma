
const router = require('express').Router();
const pool = require('../core/Pool');
const { request } = require('express');
var formidable = require('formidable');
var fs = require('fs');
var mv = require('mv');
var nodemailer = require('nodemailer');
var QRCode = require('qrcode')
const ASPC = require('../core/patient_ASPC');
var aspc = new ASPC();



router.get('/',  (request, Response) => {
    console.log("in Main Hall Get");

    console.log(typeof (request.session.user));

    if (typeof(request.session.user) == "undefined") {
        Response.redirect('home');
    }
    else {
        Response.render('mainHallForPatient', {
        title: "Main Hall",
        css: "mainHallForPatient",
        js: "mainHallForPatient",
        img: "checklist.png",
        add: "",
        type: request.session.user.User_type,

    });
}

    
});



router.post('/', (req, res) => {

    console.log("in medical Post");
    var result;
    console.log(req.body);

    switch (req.body.type  /*data i get from ajax object*/) {
        case "search":
            aspc.getScan(req.body.phone, res.end);
            break;
        case "Analysis":
            aspc.getAnalysis(req.body.phone, res.end);
            break;

        case "Prescriptions":
            aspc.getPrescriptions(req.body.phone, res.end);
            break;


        case "getMyPatients":
            aspc.getMyPatient(1,res.end);
            break;

        case "chronicDisease":
            aspc.getCoronicDisease(req.body.phone, res.end);
            break;

        case "search_for_pharmacy":
            aspc.search_for_pharmacy(req.body.searchField, res.end);
            break;

        case "search_for_Medicines":
            aspc.search_for_Medicines(req.body.searchField, res.end);
            break;

        case "barcode":
            // console.log("i will send");
            // console.log(req.body.barcode);
            // var transporter = nodemailer.createTransport({
            //     service: 'gmail',
            //     auth: {
            //         user: 'mostafamagdi999.mm@gmail.com',
            //         pass: 'Mosstafalover999'
            //     }
            // });
            // // <svg class='barcode' jsbarcode-format='upc' jsbarcode-value='123456789012' jsbarcode-textmargin='0' jsbarcode- fontoptions='bold' displayValue='false' > </svg >
            // var mailOptions = {
            //     from: 'mostafamagdi999.mm@gmail.com',
            //     to: 'mostafamagdy999.mm@gmail.com',
            //     subject: 'Sending Email using Node.js',
            //     attachDataUrls: true,//to accept base64 content in messsage
            //     html: 'wow <img class="barcode" src="' + req.body.barcode + '">' 
            // };

            // transporter.sendMail(mailOptions, function (error, info) {
            //     if (error) {
            //         console.log(error);
            //     } else {
            //         console.log('Email sent: ' + info.response);
            //     }
            // });

            break;

        default:
           
            console.log("i Will Download File default");
            var form = new formidable.IncomingForm();
            form.parse(req,  function (err, fields, files) {
                console.log(fields);
                switch (fields.typeoftheaddeditem) {
                    case "0":
                         pool.query("INSERT INTO scan (`Scan_Name`, `Scan_Date`, `Result`, `Patient_acc_ID`) VALUES ('" + fields.nameoftheitem + "','" + fields.dateofsubmition + "','" + files.filetoupload.name + "','" + fields.searchField + "');", (error, rows) => {
                            if (error)
                                throw error;
                            else {

                                result = JSON.stringify(rows);

                                console.log("added to scans succ");

                            }
                        });
                        break;
                    case "1":
                         pool.query("INSERT INTO analysis (`Analysis_Name`, `Analysis_Date`, `Result`, `Patient_acc_ID`) VALUES ('" + fields.nameoftheitem + "','" + fields.dateofsubmition + "','" + files.filetoupload.name + "','" + fields.searchField + "');", (error, rows) => {
                            if (error)
                                throw error;
                            else {

                                result = JSON.stringify(rows);

                            }
                        });

                        break;
                    case "2":
                        pool.query("INSERT INTO prescription (`Prescription_diagnosis`, `Prescription_date`, `Patient_acc_ID`, `doctor_acc_ID`) VALUES ('" + files.filetoupload.name + "','" + fields.dateofsubmition + "','" + fields.searchField + "' , 3);", (error, rows) => {
                            if (error)
                                throw error;
                            else {

                                result = JSON.stringify(rows);

                                console.log("added to pres succ");
                            }
                        });
                        break;
                }
                var oldpath = files.filetoupload.path;
                //new path to save in our files
                var newpath = 'F:/Mostafa/CMP 2/semester 1/DB-MS/Pharmacy App/public/pdfs/' + files.filetoupload.name;

                mv(oldpath, newpath, function (err) {
                    if (err) throw err;
                    res.redirect('/main-Hall');

                });
            });

            break;

    }



});
module.exports = router;