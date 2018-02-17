var NotificationsController = function($scope, $http) {
  this.$http = $http;
  this.$scope = $scope;
};

NotificationsController.prototype.getNotifications = function(id, locale, $event) {
  var self = this;
  var notifyCounter = document.querySelector('.notify-count');

  this.$http({
      method: 'POST',
      url: "/" + locale + '/notifications/' + id + '/read'
  }).then(function successCallback(response) {
      $event.target.parentNode.classList.add('read-notification');
      if (self.unreadNotificationsCount > 0) {
        self.unreadNotificationsCount--;
      };
      if (!self.unreadNotificationsCount) {
        notifyCounter.classList.add('notify-count_hidden');
      }
  });
}

NotificationsController.prototype.showNotificationsWindow = function(e) {
  if (this.$scope.$root.activePopup === "notifications") {
    this.$scope.$root.activePopup = null;
  } else {
    this.$scope.$root.activePopup = "notifications";
  }
  var ringButton = document.querySelector('.notify-link');
  var notifyWindow = document.querySelector('.alarm-notifications');
  ringButton.getBoundingClientRect();
  e.stopPropagation();
};
