(function() {
  var m;

  m = angular.module('zombbApp', ['zombb.auth', 'zombb.topic', 'zombb.user', 'zombb.dashboard', 'ngRoute', 'ngSanitize']);

  m.config([
    '$routeProvider', '$provide', function($routeProvider, $provide) {
      var baseSrcPath;
      baseSrcPath = '/demo';
      $provide.value('baseSrcPath', baseSrcPath);
      $routeProvider.when('/topics', {
        templateUrl: "" + baseSrcPath + "/topic-list.html",
        controller: 'TopicListCtrl'
      }).when('/topics/new', {
        templateUrl: "" + baseSrcPath + "/topic.html",
        controller: 'TopicNewCtrl'
      }).when('/topics/:topic_id/edit', {
        templateUrl: "" + baseSrcPath + "/topic.html",
        controller: 'TopicEditCtrl'
      }).when('/topics/:topic_id', {
        templateUrl: "" + baseSrcPath + "/topic.html",
        controller: 'TopicCtrl'
      }).when('/users/:user_id', {
        templateUrl: "" + baseSrcPath + "/user.html",
        controller: 'UserCtrl'
      }).when('/users/:user_id/edit', {
        templateUrl: "" + baseSrcPath + "/user.html",
        controller: 'UserEditCtrl'
      }).when('/register', {
        templateUrl: "" + baseSrcPath + "/user.html",
        controller: 'UserRegisterCtrl'
      }).when('/dashboard', {
        templateUrl: "" + baseSrcPath + "/dashboard.html",
        controller: 'DashboardCtrl'
      }).otherwise({
        redirectTo: '/topics'
      });
      return null;
    }
  ]);

  m.controller('NavCtrl', [
    '$scope', 'Auth', 'Authorize', function($scope, Auth, Authorize) {
      $scope.Authorize = Authorize;
      return null;
    }
  ]);

}).call(this);

(function() {
  var m;

  m = angular.module('zombb.auth', ['ngResource', 'Devise', 'ui.bootstrap']);

  m.config([
    'AuthProvider', function(AuthProvider) {
      return null;
    }
  ]);

  m.config([
    'AuthInterceptProvider', function(AuthInterceptProvider) {
      AuthInterceptProvider.interceptAuth(true);
      return null;
    }
  ]);

  m.run([
    'Auth', function(Auth) {
      return Auth.login();
    }
  ]);

  m.factory('Authorize', [
    'Auth', function(Auth) {
      var role;
      role = {
        admin: 'admin',
        editor: 'editor',
        reader: 'reader'
      };
      this.condition = {
        owner: function(user) {
          var _ref;
          return (user && ((_ref = Auth._currentUser) != null ? _ref.name : void 0) === user.name) || this.admin();
        },
        auth: function() {
          return Auth.isAuthenticated();
        },
        admin: function() {
          var _ref;
          return this.auth() && ((_ref = Auth._currentUser) != null ? _ref.role : void 0) === role.admin;
        },
        editor: function() {
          var _ref;
          return this.auth() && (((_ref = Auth._currentUser) != null ? _ref.role : void 0) === role.editor || this.admin());
        },
        reader: function() {
          var _ref;
          return this.auth() && (((_ref = Auth._currentUser) != null ? _ref.role : void 0) === role.reader || this.admin());
        },
        editor_owner: function(user) {
          return this.editor() || this.owner(user);
        }
      };
      return this;
    }
  ]);

  m.controller('AuthCtrl', [
    '$scope', '$modal', 'Auth', 'Authorize', function($scope, $modal, Auth, Authorize) {
      $scope.Auth = Auth;
      $scope.Authorize = Authorize;
      $scope.templateUrl = 'zombbAuthCtrl.html';
      $scope.open = function(size) {
        var dialog, doLogin;
        dialog = $modal.open({
          templateUrl: $scope.templateUrl,
          template: $scope.template,
          controller: 'AuthDialogCtrl',
          controllerAs: 'authDialog',
          scope: $scope,
          size: size
        });
        doLogin = function(credentials) {
          return Auth.login(credentials).then((function() {}), function(error) {
            $scope.open();
            return $scope.error = error.data.error;
          });
        };
        dialog.result.then(doLogin);
        return dialog;
      };
      $scope.$on('devise:unauthorized', function(event, xhr, deferred) {
        return $scope.open().result.then(function() {
          return $http(xhr.config);
        }).then(function(response) {
          return deferred.resolve(response);
        });
      });
      $scope.$on('devise:login', function(event, currentUser) {
        return $scope.currentUser = currentUser;
      });
      $scope.$on('devise:logout', function(event, oldUser) {
        return $scope.currentUser = null;
      });
      return null;
    }
  ]);

  m.controller('AuthDialogCtrl', [
    '$scope', '$modalInstance', function($scope, dialog) {
      $scope.ok = function() {
        return dialog.close({
          email: $scope.email,
          password: $scope.password
        });
      };
      $scope.cancel = function() {
        return dialog.dismiss('cancel');
      };
      return null;
    }
  ]);

}).call(this);

(function() {
  var m;

  m = angular.module('zombb.dashboard', ['zombb.auth', 'zombb.util']);

  m.controller('DashboardCtrl', [
    '$scope', '$http', '$location', 'Authorize', 'ConfirmDialog', function($scope, $http, $location, Authorize, ConfirmDialog) {
      if (!Authorize.condition.admin()) {
        $location('/');
      }
      $http.get('/stats.json').success(function(data) {
        return $scope.stats = data;
      }).error(function(error) {
        return $scope.error = error.data;
      });
      $http.get('/users.json').success(function(data) {
        return $scope.users = data;
      }).error(function(error) {
        return $scope.error = error.data;
      });
      $scope.getRoleIcon = function(user) {
        var icons;
        icons = {
          admin: 'cogs',
          reader: 'eye',
          editor: 'edit'
        };
        return icons[user.role];
      };
      $scope.getRoleColor = function(user) {
        var colors;
        colors = {
          admin: 'danger',
          editor: 'warning',
          reader: 'success'
        };
        return colors[user.role];
      };
      return $scope.deleteUser = function(user) {
        var dialog, doDelete;
        dialog = ConfirmDialog($scope, {
          title: "Confirm cancel account?"
        });
        doDelete = function(rest) {
          return $http["delete"]("/users/" + user.id + ".json").error(function(error) {
            return $scope.error = error.data;
          });
        };
        return dialog.result.then(doDelete);
      };
    }
  ]);

}).call(this);

(function() {
  var m;

  m = angular.module('zombb.topic', ['ngResource', 'ui.bootstrap', 'monospaced.elastic', 'zombb.auth', 'zombb.util']);

  m.factory('Post', [
    '$resource', function($resource) {
      return $resource('/posts/:post_id.json', {
        post_id: '@id'
      }, {
        update: {
          method: 'PUT'
        }
      });
    }
  ]);

  m.factory('PostComment', [
    '$resource', function($resource) {
      return $resource('/posts/:post_id/post_comments/:c_id.json', {
        post_id: '@post_id',
        c_id: '@id'
      }, {
        update: {
          method: 'PUT'
        }
      });
    }
  ]);

  m.controller('TopicListCtrl', [
    '$scope', '$modal', 'Auth', 'Authorize', 'Post', 'ConfirmDialog', function($scope, $modal, Auth, Authorize, Post, ConfirmDialog) {
      $scope.Authorize = Authorize;
      $scope.posts = [];
      Post.query((function(posts) {
        return angular.forEach(posts, function(post) {
          return $scope.posts.push(post);
        });
      }));
      $scope.deleteTopic = function(post) {
        var dialog, doDelete;
        dialog = ConfirmDialog($scope, {
          title: 'Confirm delete topic?'
        });
        doDelete = function(res) {
          return post.$delete().then((function() {
            return $scope.posts.splice($scope.posts.indexOf(post), 1);
          }), (function(error) {
            return $scope.error = error.data;
          }));
        };
        return dialog.result.then(doDelete);
      };
      return null;
    }
  ]);

  m.controller('TopicCtrl', [
    '$scope', '$routeParams', 'Auth', 'Authorize', 'Post', 'PostComment', 'ConfirmDialog', function($scope, $routeParams, Auth, Authorize, Post, PostComment, ConfirmDialog) {
      $scope.Authorize = Authorize;
      Post.get({
        post_id: $routeParams.topic_id
      }, function(post) {
        return $scope.post = post;
      });
      $scope.editComment = function(comment) {
        comment.editmode = true;
        return PostComment.get({
          post_id: $routeParams.topic_id,
          c_id: comment.id,
          edit: true
        }, function(rcomment) {
          return $scope.edit_comment = rcomment;
        });
      };
      $scope.cancelEditComment = function(comment) {
        comment.editmode = void 0;
        return $scope.edit_comment = null;
      };
      $scope.saveComment = function(comment) {
        comment.editmode = void 0;
        $scope.edit_comment.$update({
          post_id: $scope.post.id
        });
        return PostComment.get({
          post_id: $scope.post.id,
          c_id: comment.id
        }, function(rcomment) {
          return comment.text = rcomment.text;
        });
      };
      $scope.deleteComment = function(comment) {
        var dialog, doDelete;
        dialog = ConfirmDialog($scope, {
          title: 'Confirm delete comment?'
        });
        doDelete = function(res) {
          return PostComment.get({
            post_id: $scope.post.id,
            c_id: comment.id
          }, function(rcomment) {
            var comment_index;
            return rcomment.$delete({
              post_id: $scope.post.id
            }).then((function() {}, comment_index = $scope.post.post_comments.indexOf(comment), $scope.post.post_comments.splice(comment_index, 1)), function(error) {
              return $scope.error = error.data;
            });
          });
        };
        return dialog.result.then(doDelete);
      };
      $scope.new_comment = new PostComment();
      $scope.addComment = function() {
        return $scope.new_comment.$save({
          post_id: $scope.post.id
        }, function(rcomment) {
          $scope.post.post_comments.push(rcomment);
          return $scope.new_comment = new PostComment();
        });
      };
      return null;
    }
  ]);

  m.controller('TopicEditCtrl', [
    '$scope', '$routeParams', '$location', 'Post', 'Auth', function($scope, $routeParams, $location, Post, Auth) {
      $scope.editmode = true;
      Post.get({
        post_id: $routeParams.topic_id,
        edit: true
      }, function(post) {
        return $scope.post = post;
      });
      $scope.submit = function() {
        return $scope.post.$update().then((function() {}, Post.get({
          post_id: $scope.post.id,
          edit: true
        }, function(post) {
          $scope.post = post;
          return $location.path('/topics/' + $scope.post.id);
        })), (function(error) {
          return $scope.error = error.data;
        }));
      };
      return null;
    }
  ]);

  m.controller('TopicNewCtrl', [
    '$scope', '$routeParams', '$location', 'Post', 'Auth', function($scope, $routeParams, $location, Post, Auth) {
      $scope.editmode = true;
      $scope.post = new Post();
      $scope.submit = function() {
        return $scope.post.$save().then((function() {}, Post.get({
          post_id: $scope.post.id,
          edit: true
        }, function(post) {
          $scope.post = post;
          return $location.path('/topics/' + $scope.post.id);
        })), (function(error) {
          return $scope.error = error.field;
        }));
      };
      return null;
    }
  ]);

}).call(this);

(function() {
  var m;

  m = angular.module('zombb.user', ['ngResource', 'zombb.auth', 'zombb.util']);

  m.factory('User', [
    '$resource', function($resource) {
      return $resource('/users/:user_id.json', {
        user_id: '@id'
      });
    }
  ]);

  m.controller('UserCtrl', [
    '$scope', '$routeParams', 'User', function($scope, $routeParams, User) {
      return User.get({
        user_id: $routeParams.user_id
      }, function(user) {
        return $scope.user = user;
      });
    }
  ]);

  m.controller('UserEditCtrl', [
    '$scope', '$routeParams', '$location', '$http', 'Auth', 'ConfirmDialog', 'User', function($scope, $routeParams, $location, $http, Auth, ConfirmDialog, User) {
      $scope.editmode = true;
      $scope.Auth = Auth;
      User.get({
        user_id: $routeParams.user_id
      }, function(user) {
        return $scope.user = user;
      });
      $scope.submit = function() {
        var successcb;
        successcb = function(user) {
          return User.get({
            user_id: $scope.user.id
          }, function(user) {
            $scope.user = user;
            return $location.path('/users/' + $scope.user.id);
          });
        };
        return $http.put('/users.json', {
          user: $scope.user.toJSON()
        }).success(successcb).error(function(error) {
          return $scope.error = error.data;
        });
      };
      $scope.cancel = function() {
        return $location.path('/users/' + $scope.user.id);
      };
      $scope.deleteAccount = function() {
        var dialog, doDelete;
        dialog = ConfirmDialog($scope, {
          title: "Confirm cancel account?"
        });
        doDelete = function(rest) {
          return $http["delete"]('/users.json', {
            user: $scope.user.toJSON()
          }).error(function(error) {
            return $scope.error = error.data;
          }).success(function(res) {
            Auth.logout();
            return $location.path('/');
          });
        };
        return dialog.result.then(doDelete);
      };
      return null;
    }
  ]);

  m.controller('UserRegisterCtrl', [
    '$scope', '$routeParams', '$location', 'Auth', function($scope, $routeParams, $location, Auth) {
      $scope.editmode = true;
      $scope.register = true;
      $scope.user = {
        name: ''
      };
      $scope.submit = function() {
        return Auth.register($scope.user).then((function(user) {
          return $location.path('/users/' + user.id);
        }), function(error) {
          return $scope.error = error.data.errors;
        });
      };
      return null;
    }
  ]);

}).call(this);

(function() {
  var m;

  m = angular.module('zombb.util', ['ui.bootstrap']);

  m.factory('ConfirmDialog', [
    '$modal', function($modal) {
      return function($scope, messages) {
        var dialog;
        $scope.templateUrl = null;
        $scope.title = (messages != null ? messages.title : void 0) || 'Confirm?';
        $scope.template = '<div class="modal-header"> <h3 class="modal-title">{{ title }}</h3> </div> <div class="modal-body"> <input type="submit" value="OK" class="btn btn-success" ng-click="ok()" /> <button class="btn btn-default" ng-click="cancel()">Cancel</button> </div>';
        return dialog = $modal.open({
          templateUrl: $scope.templateUrl,
          template: $scope.template,
          controller: 'ConfirmDialogCtrl',
          controllerAs: 'confirmDialog',
          scope: $scope
        });
      };
    }
  ]);

  m.controller('ConfirmDialogCtrl', [
    '$scope', '$modalInstance', function($scope, dialog) {
      $scope.ok = function() {
        return dialog.close(true);
      };
      $scope.cancel = function() {
        return dialog.dismiss('cancel');
      };
      return null;
    }
  ]);

}).call(this);
