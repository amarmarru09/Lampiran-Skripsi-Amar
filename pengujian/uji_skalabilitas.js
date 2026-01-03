import http from 'k6/http';
import { sleep, check } from 'k6';

/*
  MODE:
  1. TANPA redirect  -> MODE=normal
  2. DENGAN redirect -> MODE=redirect
*/

const MODE = __ENV.MODE || 'normal';

// target URL
const URL_NORMAL   = 'http://192.168.1.10/webutama/';
const URL_REDIRECT = 'http://192.168.1.21/webutama/'; 
// (redirect akan terjadi otomatis jika mekanisme redirect aktif)

export let options = {
  stages: [
    { duration: '1m', target: 50 },
    { duration: '1m', target: 100 },
    { duration: '1m', target: 200 },
    { duration: '1m', target: 300 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    http_req_failed: ['rate<0.05'], // error <5%
    http_req_duration: ['p(95)<1000'], // p95 < 1 detik
  },
};

export default function () {
  let url = MODE === 'redirect' ? URL_REDIRECT : URL_NORMAL;

  let res = http.get(url, {
    redirects: MODE === 'redirect' ? 5 : 0,
    timeout: '60s',
  });

  check(res, {
    'status is 200 or redirect': (r) =>
      r.status === 200 || r.status === 301 || r.status === 302,
  });

  sleep(1);
}
