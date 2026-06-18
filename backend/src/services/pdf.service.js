const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const generateRentalAgreementPdf = async (agreement, property, tenant, owner) => {
  const filename = `agreement-${uuidv4()}.pdf`;
  const filepath = path.join(__dirname, '../../uploads', filename);

  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ margin: 50 });
    const stream = fs.createWriteStream(filepath);
    doc.pipe(stream);

    doc.fontSize(20).fillColor('#0d2240').text('Rental Agreement', { align: 'center' });
    doc.moveDown();

    doc.fontSize(12).fillColor('#333');
    doc.text(`Property: ${property.name}`);
    doc.text(`Address: ${property.address}`);
    doc.text(`Owner: ${owner.fullName} (${owner.email})`);
    doc.text(`Tenant: ${tenant.name} (${tenant.email || tenant.mobile})`);
    doc.moveDown();
    doc.text(`Rent Amount: ₹${agreement.rentAmount}/month`);
    doc.text(`Security Deposit: ₹${agreement.securityDeposit}`);
    doc.text(`Period: ${new Date(agreement.startDate).toLocaleDateString()} - ${new Date(agreement.endDate).toLocaleDateString()}`);
    doc.moveDown();
    doc.text('Terms & Conditions:');
    doc.text(agreement.terms || 'Standard rental terms apply.');
    doc.moveDown(2);
    doc.text('_________________________          _________________________');
    doc.text('Owner Signature                      Tenant Signature');

    doc.end();
    stream.on('finish', () => resolve(`/uploads/${filename}`));
    stream.on('error', reject);
  });
};

module.exports = { generateRentalAgreementPdf };
