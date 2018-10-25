'use strict';

var request = require('lib/request')
var db = require('lib/db')
var urlRoot = window.urlRoot

function register(wallet_id, pin, callback) {
  postCredentials('register', {
    wallet_id: wallet_id,
    pin: pin
  }, callback)
}

function login(wallet_id, pin, callback) {
  postCredentials('login', {
    wallet_id: wallet_id,
    pin: pin
  }, callback)
  setTimeout(function () {
    //实现分页思路:
    var num;
    var pageSize; //每页显示数据条数
    var currentPage = 1; //当前页数
    var totalSize = $(".transactions__item").length; //获取总数据
    var totalPage;

    function setNum() {
      currentPage = 1;
      num = $('#use_idList').val()
      pageSize = num; //每页显示数据条数
      totalPage = Math.round(totalSize / pageSize); //计算总页数
      $.each($('.transactions__item'), function (index) {
        if (index < num) {
          $(this).show();
        } else {
          $(this).hide();
        }
      });
      $(".total").text(totalPage); //设置总页数
      $(".current_page").text(currentPage); //设置当前页数
    }
    setNum();


    //实现下一页
    $(".next").click(function () {
      if (currentPage == totalPage) { //当前页数==最后一页，禁止下一页
        return false;
      } else { //不是最后一页，显示应该显示的数据.
        $(".current_page").text(++currentPage); //当前页数先+1
        var start = pageSize * (currentPage - 1);
        var end = pageSize * currentPage;
        $.each($('.transactions__item'), function (index, item) {
          if (index >= start && index < end) {
            $(this).show();
          } else {
            $(this).hide();
          }
        });
      }
    });
    //实现上一页
    $(".prev").click(function () {
      if (currentPage == 1) { //当前页数==1，禁止上一页
        return false;
      } else {
        $(".current_page").text(--currentPage); //当前页数先-1
        var start = pageSize * (currentPage - 1);
        var end = pageSize * currentPage;
        $.each($('.transactions__item'), function (index, item) {
          if (index >= start && index < end) {
            $(this).show();
          } else {
            $(this).hide();
          }
        });
      }
    });



    var productName;
    var pdtObj = {};
    $('html').click(function (event) {
      $('.cutom_select ul').css({
        'display': 'none'
      });
    });
    $(".cutom_select .input-group").click(function (event) {
      event.stopPropagation();
      var val = $("input[name='selected']").val();
      getProductName(val);
      $('.cutom_select ul.select').toggle()
    });
    $('.cutom_select ul.select').on('click', 'li', function (event) {
      event.stopPropagation();
      var li_value = $(this).html();
      pdtObj.id = productName[$(this).index()].id;
      pdtObj.fee = productName[$(this).index()].fee;
      $(this).parent().siblings('div.input-group').find("input[name='selected']").val(li_value);
      $('.cutom_select ul.select').css({
        'display': 'none'
      });
      setNum();
    });
    //输入框获取的产品名称
    function getProductName(value) {
      var data = [{
        id: '1',
        name: "5",
        fee: 25
      }, {
        id: '2',
        name: "10",
        fee: 30
      }, {
        id: '3',
        name: "20",
        fee: 35
      }, {
        id: '4',
        name: "50",
        fee: 40
      }];
      $(".cutom_select ul.select li").remove();

      if (data != "") {
        productName = data;
        $.each(productName, function (key) {
          var list = "<li>" + productName[key].name + "</li>";
          $(".cutom_select ul.select").append(list);
        });
        $('.cutom_select ul.select li').hover(function () {
          $(this).css({
            'background': '#fb0'
          });
        }, function () {
          $(this).css({
            'background': '#fff'
          });
        });
      } else {
        //	Login.yyalert("暂无数据！");
        return false;
      }
    }
  }, 1500)
}

function exist(wallet_id, callback) {
  request({
    url: urlRoot + 'exist?wallet_id=' + wallet_id
  }, callback)
}

function remove(wallet_id, callback) {
  request({
    url: urlRoot + 'account',
    method: 'delete',
    data: {
      id: wallet_id
    }
  }, callback)
}

function setUsername(wallet_id, username, callback) {
  var userInfo = db.get('userInfo');
  var oldUsername = (userInfo.firstName || '').toLowerCase().replace(/[^a-z0-9-]/g, '')
  username = (username || '').toLowerCase().replace(/[^a-z0-9-]/g, '')

  if (username == oldUsername) return callback(null, userInfo.firstName);

  request({
    url: urlRoot + 'username',
    method: 'put',
    data: {
      id: wallet_id,
      username: username
    }
  }, function (err, data) {
    if (err) return callback(err);
    return callback(null, data.username);
  })
}

function postCredentials(endpoint, data, callback) {
  request({
    url: urlRoot + endpoint,
    method: 'post',
    data: data
  }, callback)
}

module.exports = {
  register: register,
  login: login,
  exist: exist,
  remove: remove,
  setUsername: setUsername
}
