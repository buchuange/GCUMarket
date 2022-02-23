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

    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>

    <script type="text/javascript">

        $.fn.datetimepicker.dates['zh-CN'] = {
            days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin: ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
            today: "今天",
            suffix: [],
            meridiem: ["上午", "下午"]
        };

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                dataFormat: 'yyyy-mm-dd',
                timeFormat: 'HH:mm:ss',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            // 打开交易的窗口
            $("#addBtn").click(function () {
                $("#createCartModal").modal("show")
            })
            // 打开付款的窗口
            $("#addInfoBtn").click(function () {
                $("#createTransactionModal").modal("show")
            })

            $("#saveCartBtn").click(function () {
                $.ajax({
                    url: "workbench/buyer/shopping/saveCart",
                    data: {
                        "goodsName": $.trim($("#create-name").val()),
                        "goodsNumber": $.trim($("#create-goodsNumber").val()),
                        "goodsPrice": '${product.price}',
                        "createTime": $.trim($("#create-purchaseDate").val()),
                        "buyerId": '${user.id}',
                        "productId": '${product.id}',
                        "businessId": '${product.businessId}'
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {

                            alert("加入购物车成功！")
                            $("#createCartModal").modal("hide")
                        } else {
                            alert("加入购物车失败！")
                        }
                    }
                })
            })

            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/buyer/shopping/saveOrder",
                    data: {
                        "goodsName": $.trim($("#create-name").val()),
                        "goodsNumber": $.trim($("#create-goodsNumber").val()),
                        "goodsPrice": '${product.price}',
                        "createTime": $.trim($("#create-purchaseDate").val()),
                        "buyerId": '${user.id}',
                        "productId": '${product.id}',
                        "businessId": '${product.businessId}',
                        "contactsPhone": $.trim($("#create-phone").val()),
                        "orderDestination": $.trim($("#create-address").val())
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {

                            alert("支付成功！")
                            $("#createTransactionModalModal").modal("hide")
                            $("#createCartModal").modal("hide")
                        } else {
                            alert("支付失败！")
                        }
                    }
                })
            })

        });

        function modifyCount(inventory) {

            // 输入的数据只能是1 ~ 库存数量,只要不是这个范围内的,归1
            var userInput = $.trim($("#create-goodsNumber").val()); // 用户输入的数据

            // 当这个数据不合法的时候归1
            if (parseInt(userInput) != userInput) {
                $("#create-goodsNumber").val("1")
            }
            // 第一个数字是1-9中的一个.第二个数字可以有也可以没有.
            var regExp = /^[1-9][0-9]*$/
            var ok = regExp.test(userInput)
            if (!ok) { //不符合正则
                $("#create-goodsNumber").val("1")
            } else {
                // 走到这里一定是数字,但是数字必须是1~库存
                if (userInput > inventory) {
                    $("#create-goodsNumber").val("1")
                }
            }
        }
    </script>

</head>
<body>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${product.name} <small><a href="javascript:void(0)" target="_blank">&nbsp;</a></small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" id="addBtn" class="btn btn-danger"><span class="glyphicon glyphicon-shopping-cart"></span> 创建交易</button>
    </div>
</div>

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createCartModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建交易</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="transactionAddForm1" role="form">

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">商品名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name" value="${product.name}" readonly>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-goodsNumber" class="col-sm-2 control-label">购买数量<span
                                    style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-goodsNumber" onblur="modifyCount(${product.inventory})" value="1" placeholder="请输入购买该商品的数量">
                            </div>
                            <label for="create-purchaseDate" class="col-sm-2 control-label">购买日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-purchaseDate" readonly>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" id="saveCartBtn">加入购物车</button>
                <button type="button" class="btn btn-danger" id="addInfoBtn">立即购买</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">个人信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="transactionAddForm" role="form">

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">联系电话<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">收获地址
                                <span style="font-size: 15px; color: red;">*</span>
                            </label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">付款</button>
            </div>
        </div>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">商品名称</div>
        <div style="width: 300px;position: relative; left: 150px; top: -20px;"><b>${product.name}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">商品类别</div>
        <div style="width: 300px;position: relative; left: 600px; top: -60px;"><b>${product.category}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">商品单价</div>
        <div style="width: 300px;position: relative; left: 150px; top: -20px;"><b>${product.price}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">商品规格</div>
        <div style="width: 300px;position: relative; left: 600px; top: -60px;"><b>${product.standards}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">库存数量</div>
        <div style="width: 300px;position: relative; left: 150px; top: -20px; color: #d58512"><b>${product.inventory}&nbsp;</b></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">商品描述</div>
        <div style="width: 630px;position: relative; left: 150px; top: -20px;">
            <b>
                &nbsp;${product.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>


<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>商品评价</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加评价..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>