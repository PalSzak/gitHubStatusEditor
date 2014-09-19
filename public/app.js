'use strict';

angular.module('GitHubStatusEditor', []).controller('StatusEditor', function($scope, $http) {
	$scope.statuses = ['pending', 'success', 'error', 'failure'];
	$scope.repositories = [];
	$scope.pullrequests = [];

	$scope.getRepositories = function(){
		$http({method: 'GET', url: '/repos/'+$scope.organization}).
		  	success(function(data, status, headers, config) {
		    	$scope.repositories = data;
		    	$scope.pullrequests = [];
		  	});
	};

	$scope.getPullRequests = function(){
		$http({method: 'GET', url: '/pullrequests/'+$scope.repository}).
		  	success(function(data, status, headers, config) {
		    	$scope.pullrequests = data;
		  	});
	};

	$scope.sendMessage = function(){
		var data = {
			full_name: $scope.repository,
			sha: $scope.pullRequest,
			state: $scope.selectedStatus,
			description: $scope.message
		};
		if(angular.isDefined(data.full_name) && 
			angular.isDefined(data.state) &&
			angular.isDefined(data.description)){

			if(angular.isDefined(data.sha)){
				$http({method: 'POST', url: '/message' , data: data});
			} else {
				$scope.pullrequests.forEach(function(pr){
					var dataFull = angular.copy(data);
					dataFull.sha = pr.sha;
					$http({method: 'POST', url: '/message' , data: dataFull});
				});
			}
		} else {
			console.log('error', data);
		}
	}

});
