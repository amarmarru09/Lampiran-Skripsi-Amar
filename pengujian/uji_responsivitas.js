import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 15,          // aman untuk responsivitas
  duration: '60s',
};

export default function () {
  let res = http.get('http://192.168.1.10/webutama/', {
    timeout: '10s',
  });
  
  check(res, {
    'status 200': (r) => r.status === 200,
  });

  sleep(1);
}
