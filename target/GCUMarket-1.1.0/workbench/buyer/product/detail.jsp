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

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
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

            showTransactionList();
        });

        function showTransactionList() {

            $.ajax({
                url: "workbench/product/showTransactionList",
                data: {
                    "productId" : "${product.id}"
                },
                dataType:"json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>'+n.name+'</td>';
                        html += '<td>'+n.purchaseQuantity+'</td>';
                        html += '<td>'+n.purchaseDate+'</td>';
                        html += '</tr>';
                    })

                    $("#transactionBody").html(html)
                }
            })
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
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">

    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">产品名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${product.name}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">产品类别</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${product.categoryId}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">产品单价</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${product.price}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">产品规格</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${product.standards}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">库存数量</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${product.inventory}&nbsp;</b><small
                style="font-size: 10px; color: gray;">&nbsp;</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 50px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${product.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${product.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 50px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${product.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${product.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${product.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!--销售列表-->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>销售列表</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="transactionTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>客户名称</td>
                    <td>购买数量</td>
                    <td>购买日期</td>
                </tr>
                </thead>
                <tbody id="transactionBody">

                </tbody>
            </table>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>