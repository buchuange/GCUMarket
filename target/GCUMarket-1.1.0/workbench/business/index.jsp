<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <link href="jquery/bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script type="text/javascript">

        //页面加载完毕
        $(function () {

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color", "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color", "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function () {
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color", "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color", "white");
            });

            // 在页面加载完毕后，在工作区打开相应的页面
            window.open("workbench/business/main/index.jsp", "workareaFrame");


            $("#oldPwd, #newPwd, #confirmPwd").focus(function () {
                $("#errorMsg").html("")
            })

            // 打开修改密码操作的模态窗口
            $("#editBtn").click(function () {

                $("#updatePwdForm").get(0).reset()
                $("#errorMsg").html("")

                $("#editPwdModal").modal("show")
            })
            // 为更新密码按钮，绑定事件
            $("#updateBtn").click(function () {

                var oldPwd = $.trim($("#oldPwd").val());
                var newPwd = $.trim($("#newPwd").val());
                var confirmPwd = $.trim($("#confirmPwd").val());

                if (oldPwd=="" || newPwd=="" || confirmPwd=="") {
                    $("#errorMsg").html("信息填写不完整，请填写完整信息！")
                    return false;
                }
                if (newPwd != confirmPwd) {
                    $("#errorMsg").html("两次密码输入不一致，请重新输入！")
                    return false;
                }
                $.ajax({
                    url: "business/user/updatePwd",
                    data: {
                        oldPwd: oldPwd,
                        newPwd: newPwd,
                        id: "${user.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("修改密码成功，请重新登录！");
                            window.location.href = "business_login.jsp"
                            $("#editPwdModal").modal("hide")
                        } else {
                            $("#errorMsg").html(data.msg)
                        }
                    }
                })
            })
        });

    </script>

</head>
<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${user.contacts}</b><br><br>
                    登录帐号：<b>${user.loginAct}</b><br><br>
                    联系电话：<b>${user.contactPhone}</b><br><br>
                    商家网站：<b>${user.website}</b><br><br>
                    失效时间: <b>${user.expireTime}</b><br><br>
                    商家介绍：<b>${user.introduce}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 60%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="updatePwdForm">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="oldPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
                            <span id="errorMsg" style="color: #FF0000; font-size: 16px; font-weight: bold"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="window.location.href='business_login.jsp';">确定
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 70px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 15px; left: 50px; font-size: 24px; font-weight: 400; color: white; font-family: 'times new roman'">
        城理饿了么系统 &nbsp;<span style="font-size: 14px;">&copy;商家版</span></div>
    <div style="position: absolute; top: 20px; right: 80px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: snow; margin-right: 60px" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user" style="font-size: 16px"></span>&nbsp;&nbsp;
                    <span style="font-size: 16px">${user.name}</span>
                    <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span
                            class="glyphicon glyphicon-file"></span> 我的资料</a></li>
                    <li><a href="javascript:void(0)" id="editBtn"><span
                            class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span
                            class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 70px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto; background-color: #4a8e9e">

        <ul id="no1" class="nav nav-pills nav-stacked">
            <li class="liClass"><a href="workbench/business/main/index.jsp" target="workareaFrame"><span
                    class="glyphicon glyphicon-home"></span> 工作台</a></li>
            <li class="liClass"><a href="workbench/business/product/index.jsp" target="workareaFrame"><span
                    class="glyphicon glyphicon-leaf"></span> 商品管理</a></li>
            <li class="liClass"><a href="workbench/business/transaction/index.jsp" target="workareaFrame"><span
                    class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
        </ul>

        <!-- 分割线 -->
        <div id="divider1"
             style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px; background-color: slategray"></div>

</body>
</html>