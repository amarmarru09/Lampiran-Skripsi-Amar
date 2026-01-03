import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  vus: 10,
  duration: '1m',
  maxRedirects: 0,   // penting karena sistem kamu pakai redirect
};

export default function () {
  http.get('http://192.168.1.10/webutama', {
    redirects: 0
  });
  sleep(1);
}
