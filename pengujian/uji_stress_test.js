import http from 'k6/http';
import { sleep, check } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 50 },    // naik pelan
    { duration: '1m', target: 200 },   // mulai panas
    { duration: '1m', target: 500 },   // stress
    { duration: '1m', target: 1000 },  // OVERLOAD
    { duration: '1m', target: 0 },     // cooldown
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'], // toleransi 3 detik
    http_req_failed: ['rate<0.3'],     // max 30% error
  },
};

export default function () {
  let res = http.get('http://192.168.1.10/webutama/'); // server utama
  check(res, {
    'status is 200 or redirect': (r) => r.status === 200 || r.status === 301 || r.status === 302,
  });
  sleep(1);
}
