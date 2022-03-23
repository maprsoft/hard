var pdfmake = require('pdfmake');
var PdfPrinter = require('pdfmake');

var fonts = {
    Roboto: {
        normal: 'fonts/Roboto-Regular.ttf',
        bold: 'fonts/Roboto-Medium.ttf',
        italics: 'fonts/Roboto-Italic.ttf',
        bolditalics: 'fonts/Roboto-MediumItalic.ttf'
    }
};

var printer = new PdfPrinter(fonts);
var fs = require('fs');

var docDefinition = {
    pageSize: 'A4',
    pageOrientation: 'landscape',
    header: {
        columns: [
            { text: "Hardening Report", alignment: 'left', margin: [25, 15, 0, 0] },
            { image: 'img/logo.png', fit: [35, 35], margin: [370, 5, 0, 0] }
        ]
    },
    content: [
        {
            columnGap: 0,
            alignment: 'justify',
            width: '50%',
            columns: [
                [
                    { text: 'Compliance Checks by Types', bold: true, margin: [0, 0, 0, 5], fontSize: 18 },
                    {
                        table: {
                            margin: [10, 10, 0, 0],
                            widths: [ 80, 55, 55, 55 ],
                            body: [
                                [ '', [{text: 'Systems', alignment: 'center', fontSize: 11}], [{text: 'Passed', alignment: 'center', fontSize: 11}], [{text: 'Failed', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Filesystem', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'OS', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Network', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Auditd', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Security', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                            ]
                        },
                        layout: {
                            fillColor: function (rowIndex, node, columnIndex) {
                                return (rowIndex % 6 === 0) ? '#e6e6e6' : null;
                            }
                        }
                           
                    },
                    { text: 'Compliance Checks by OS', bold: true, margin: [0, 10, 0, 5], fontSize: 18 },
                    {
                        table: {
                            margin: [0, 0, 0, 0],
                            widths: [ 80, 55, 55, 55 ],
                            body: [
                                [ '', [{text: 'Systems', alignment: 'center', fontSize: 11}], [{text: 'Passed', alignment: 'center', fontSize: 11}], [{text: 'Failed', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Linux', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Windows', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'Database', alignment: 'left', fontSize: 11}], [{text: '8', alignment: 'center', fontSize: 11}], [{text: '6', alignment: 'center', fontSize: 11}], [{text: '2', alignment: 'center', fontSize: 11}] ],
                            ]
                        },
                        layout: {
                            fillColor: function (rowIndex, node, columnIndex) {
                                return (rowIndex % 6 === 0) ? '#e6e6e6' : null;
                            }
                        }
                    }
                ],
                [
                    { text: 'Top Compliance Checks', bold: true, margin: [0, 0, 0, 5], fontSize: 18 },
                    {
                        table: {
                            margin: [0, 0, 0, 0],
                            widths: [ 240, 55, 55 ],
                            body: [
                                [ [{text: '', alignment: 'center', fontSize: 11}], [{text: 'Type', alignment: 'center', fontSize: 11}], [{text: 'Total', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                                [ [{text: 'ensure SSH root login is disabled', alignment: 'left', fontSize: 11}], [{text: 'Security', alignment: 'center', fontSize: 11}], [{text: '37', alignment: 'center', fontSize: 11}] ],
                            ]
                        },
                        layout: {
                            fillColor: function (rowIndex, node, columnIndex) {
                                return (rowIndex % 20 === 0) ? '#e6e6e6' : null;
                            }
                        }
                    }
                ]
            ]
        }
    ]
}

var pdfDoc = printer.createPdfKitDocument(docDefinition);
pdfDoc.pipe(fs.createWriteStream('report.pdf'));
pdfDoc.end();