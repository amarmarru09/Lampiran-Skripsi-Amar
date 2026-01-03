import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '30s', target: 100 },
    { duration: '30s', target: 200 },
    { duration: '30s', target: 0 },
  ],
};

export default function () {
  const url = 'http://192.168.1.10/webutama/';
  const res = http.get(url, { redirects: 0 }); // penting: redirect dimatiin

  check(res, {
    'status is 200 (normal)': (r) => r.status === 200,
    'redirect detected (301/302)': (r) =>
      r.status === 301 || r.status === 302,
  });

  sleep(1);
}
