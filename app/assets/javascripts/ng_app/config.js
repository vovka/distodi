var Config = function($httpProvider) {
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
};
