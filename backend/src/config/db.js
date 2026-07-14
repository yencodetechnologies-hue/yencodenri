const dns = require('dns');
const mongoose = require('mongoose');
const config = require('./env');

// Windows / ISP DNS often refuses MongoDB SRV lookups (querySrv ECONNREFUSED).
// Prefer public resolvers for Atlas mongodb+srv URIs.
if (config.mongodbUri.startsWith('mongodb+srv://')) {
  dns.setServers(['8.8.8.8', '1.1.1.1']);
}

const sanitizeMongoHost = (uri) => {
  try {
    const withoutCreds = uri.replace(/\/\/([^@]+)@/, '//***:***@');
    const match = withoutCreds.match(/@([^/?]+)/) || withoutCreds.match(/\/\/([^/?]+)/);
    return match ? match[1] : withoutCreds;
  } catch {
    return 'unknown';
  }
};

const connectDB = async () => {
  const host = sanitizeMongoHost(config.mongodbUri);
  try {
    await mongoose.connect(config.mongodbUri);
    console.log(`MongoDB connected (${host})`);
  } catch (error) {
    console.error(`MongoDB connection error (${host}):`, error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
