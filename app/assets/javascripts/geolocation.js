var __geoLoc__ = {};

var GeoLocation = {
  navigator: Object.create(navigator),
  result: function() {
    return __geoLoc__ ;
  }
};

GeoLocation.init = function() {
  this.navigator.geolocation.getCurrentPosition(
    function(position) {
      __geoLoc__.position = position;
    },
    function(error) {
      __geoLoc__.error = error;
    },
    {
      enableHighAccuracy: true,
      maximumAge: 0
    }
  );
}

var ComputeLocation = {
  init: function(geocoder, geoInfo, localities,container) {
    this.geocoder = geocoder;
    this.geoInfo = geoInfo;
    this.localities = localities;
  },
  results: function() {
    return __geoLoc__.results;
  }
}

ComputeLocation.start = function() {
  if(this.geoInfo.position) {
    this.process(
      this.geoInfo.position.coords.latitude,
      this.geoInfo.position.coords.longitude
    );
  } else {
    ComputeLocation.manualLocation(
      'GPS is disabled on your device. or Please select the location.'
    );
  }
};

ComputeLocation.process = function(lat,lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  this.geocoder.geocode({'location': latlng}, function(results,status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
        $.cookie('_lat',parseFloat(lat).toFixed(6));
        $.cookie('_lon',parseFloat(lng).toFixed(6));
        __geoLoc__.results =  results;
      } else {
        ComputeLocation.manualLocation();
      }
    } else {
      ComputeLocation.manualLocation();
    }
  });
};

ComputeLocation.manualLocation = function(msg) {
  var m = msg? msg : 'Select your Location';

  $('#selectLocation .modal-title').html(m);

  $('#selectLocation').modal({
    backdrop: 'static',
    keyboard: false
  });
};

ComputeLocation.matchLocality = function(addr) {
  var localities = this.localities;
  var address = $.map(addr.split(','), $.trim);

  var result = address.filter(function(n) {
    return localities.indexOf(n) != -1
  });

  if (result.length > 0) {
    return result;
  } else {
    this.manualLocation(
      'Unable to locate the correct address. Please select the location.'
    );
  }
};

ComputeLocation.updateAddress = function(addr) {
  $('.btn-loc span').html(addr);
  $.cookie('_locality',addr);
  var date = new Date();
  $.cookie('_updated_at',date.getTime());
  this.updatePlaces();
};

ComputeLocation.updatePlaces = function() {
  $.get(
    '/searches/places',
    {
      area: $.cookie('_locality'),
      lat: $.cookie('_lat'),
      lon: $.cookie('_lon'),
      radius: 5
    },
    function(data) {
      $('#places .content').html(data);
    }
  );
};

ComputeLocation.setLocation = function(addr) {
  this.updateAddress(addr);
};




