const User = require('../models/User');
const FeeConfig = require('../models/FeeConfig');
const config = require('../config/env');

const defaultFees = [
  { serviceType: 'annual_subscription', feeType: 'Annual Subscription', amount: 12000, description: 'Per property per year + 18% GST' },
  { serviceType: 'legal_verification', feeType: 'Legal Fee', amount: 2500, description: 'Property legal verification' },
  { serviceType: 'rental_agreement', feeType: 'Documentation Fee', amount: 1500, description: 'Rental agreement documentation' },
  { serviceType: 'tenant_verification', feeType: 'Service Fee', amount: 1000, description: 'Tenant background verification' },
  { serviceType: 'property_listing', feeType: 'Listing Fee', amount: 3000, description: 'Property listing fee' },
  { serviceType: 'property_rental', feeType: 'Brokerage Fee', amount: 5000, description: 'Property rental brokerage' },
  { serviceType: 'property_sale', feeType: 'Brokerage Fee', amount: 10000, description: 'Property sale brokerage' },
  { serviceType: 'maintenance_services', feeType: 'Service Fee', amount: 500, description: 'Maintenance service fee' },
  { serviceType: 'construction_services', feeType: 'Project-Based Fee', amount: 0, description: 'Quoted per project' },
];

const seedAdmin = async () => {
  const existing = await User.findOne({ email: config.adminEmail });
  if (!existing) {
    const passwordHash = await User.hashPassword(config.adminPassword);
    await User.create({
      fullName: 'Admin',
      email: config.adminEmail,
      mobile: '9999999999',
      passwordHash,
      role: 'admin',
      isVerified: true,
      termsAccepted: true,
      privacyAccepted: true,
    });
    console.log('Admin user seeded');
  }
};

const seedFees = async () => {
  for (const fee of defaultFees) {
    await FeeConfig.findOneAndUpdate({ serviceType: fee.serviceType }, fee, { upsert: true });
  }
  console.log('Fee config seeded');
};

const runSeed = async () => {
  await seedAdmin();
  await seedFees();
};

module.exports = { runSeed };
