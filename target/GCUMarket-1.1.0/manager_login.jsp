<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-3.3.7-dist/js/bootstrap.js"></script>

    <script>

        $(function () {

            if (window.top != window) {
                window.top.location = window.location;
            }

            //页面加载完毕后，将用户文本框中的内容清空
            $("#loginAct").val("");

            //页面加载完毕后，让用户的文本框自动获得焦点
            $("#loginAct").focus();


            //为登录按钮绑定事件，执行登录操作
            $("#submitBtn").click(function () {
                login();
            })

            //为当前登录的窗口绑定敲键盘事件
            //event:这个参数可以取得我们敲的是哪个键
            $(window).keydown(function (event) {

                //如果取得的键位的码值为13，表示敲的是回车键
                if (event.keyCode == 13) {
                    login();
                }
            })

            $("#loginAct, #loginPwd").focus(function () {
                $("#msg").html("");
            })
        })

        function login() {

            //验证账号密码不能为空
            //取得账号密码
            //将文本中的左右空格去掉，使用$.trim(文本)
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());

            if (loginAct == "" || loginPwd == "") {

                $("#msg").html("账号或密码不能为空");
                return false;
            }

            //去后台验证登录相关操作
            $.ajax({

                url: "settings/user/login",
                data: {
                    "loginAct": loginAct,
                    "loginPwd": loginPwd

                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    //如果登录成功
                    if (data.success) {

                        //跳转到工作台的初始页（欢迎页）
                        window.location.href = "workbench/settings/index.jsp";

                        //如果登录失败
                    } else {
                        $("#msg").html(data.msg);
                    }
                }
            })
        }

    </script>

</head>
<body>
<div style="position: absolute; top: 30px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 80px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 20px; left: 500px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        城理饿了么系统 &nbsp;<span style="font-size: 15px;">&copy;2021&nbsp;钟俊杰</span></div>
</div>

<div style="position: absolute; top: 150px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/settings/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: #FF0000; font-size: 16px; font-weight: bold"></span>

                </div>

                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>