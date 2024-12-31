final class Environment {
   static const jwtSecret = String.fromEnvironment(
    'JWT_SECRET',
    defaultValue: '2767b9cc84ee03bc7361e06c2553cef9fa4474e6b01dc678698b0c7203f750628df92c47da2f05e7dfbc48a126d730e36d7ac1af933087148b1fbb85aeb5036bdfa03d000024eec2690d76be231070eaa30616311e6016d11889b87aa61770a3d8675f23fbc04165edf7a81ca3d00e8867eb8be91605dff17e7f74b45e00293f7981c4fd616897d40f0542f16cf94203e584b095afeb1298fc50a6046db9c726a2ef228a9ae46cf76ed78e114239d2fec17f4520b63c3ed9e94fadddfb1b0818956971f63051c2a9203dbb030b0e9d9ace27ea57ecf99c20e4e5e9064ed60efcf0aef003381f335baccdc84a5850a2330a5f7818afaadf61166398e4ce02a669'
  );
  static const jwtExpirationDays = int.fromEnvironment(
    'JWT_EXPIRATION_DAYS',
    defaultValue: 30
  );

  static const userBackend = String.fromEnvironment(
    'username',
    defaultValue: '1000409288'
  );

  static const passwordBackend = String.fromEnvironment(
    'password',
    defaultValue: '147852369z@Gab'
  );
}