const crypto = require('crypto');
const config = require('../config/env');

const getPayuBaseUrl = () =>
  config.payu.env === 'production' ? 'https://secure.payu.in' : 'https://test.payu.in';

const generateTxnId = (prefix = 'txn') =>
  `${prefix}_${Date.now()}_${Math.floor(Math.random() * 10000)}`;

const buildRequestHash = ({ key, txnid, amount, productinfo, firstname, email, salt }) => {
  const hashString = `${key}|${txnid}|${amount}|${productinfo}|${firstname}|${email}|||||||||||${salt}`;
  return crypto.createHash('sha512').update(hashString).digest('hex');
};

const buildResponseHash = ({ salt, status, email, firstname, productinfo, amount, txnid, key }) => {
  const hashString = `${salt}|${status}|||||||||||${email}|${firstname}|${productinfo}|${amount}|${txnid}|${key}`;
  return crypto.createHash('sha512').update(hashString).digest('hex');
};

const createOrder = async (amount, receipt, notes = {}) => {
  const txnid = generateTxnId(receipt);
  const productinfo = notes.description || receipt;
  const firstname = notes.firstname || 'Customer';
  const email = notes.email || 'customer@example.com';
  const phone = notes.phone || '9999999999';
  const amountStr = Number(amount).toFixed(2);

  const { key, salt } = config.payu;

  if (!key || !salt) {
    return {
      id: txnid,
      txnid,
      amount: amountStr,
      currency: 'INR',
      dev: true,
    };
  }

  const hash = buildRequestHash({
    key,
    txnid,
    amount: amountStr,
    productinfo,
    firstname,
    email,
    salt,
  });

  return {
    id: txnid,
    txnid,
    amount: amountStr,
    currency: 'INR',
    key,
    hash,
    productinfo,
    firstname,
    email,
    phone,
    surl: `${config.appUrl}/api/payments/payu/success`,
    furl: `${config.appUrl}/api/payments/payu/failure`,
    paymentUrl: `${getPayuBaseUrl()}/_payment`,
    serviceProvider: 'payu_paisa',
  };
};

const verifyPaymentCallback = (params) => {
  const {
    status,
    txnid,
    amount,
    productinfo,
    firstname,
    email,
    hash,
    key,
  } = params;

  if (!config.payu.salt || !config.payu.key) {
    return status === 'success';
  }

  const expectedHash = buildResponseHash({
    salt: config.payu.salt,
    status,
    email: email || '',
    firstname: firstname || '',
    productinfo: productinfo || '',
    amount,
    txnid,
    key: key || config.payu.key,
  });

  return expectedHash === hash && status === 'success';
};

module.exports = {
  createOrder,
  verifyPaymentCallback,
  getPayuBaseUrl,
};
