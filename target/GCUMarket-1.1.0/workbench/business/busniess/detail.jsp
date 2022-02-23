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

            // 页面加载完毕后，取出关联的产品信息列表
            showProductList();
        });

        function showProductList() {

            $.ajax({
                url: "workbench/category/getProductListByCategoryId",
                data: {
                    "categoryId": "${category.id}"
                },
                dataType: "json",
                success: function (data) {

                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td><a href="workbench/product/detail?id='+n.id+'" style="text-decoration: none;">'+n.name+'</a></td>';
                        html += '<td>'+n.standards+'</td>';
                        html += '<td>'+n.price+'</td>';
                        html += '<td>'+n.inventory+'</td>';
                        html += '<td><a href="javascript:void(0);" onclick="removeProduct(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
                        html += '</tr>';
                    })

                    $("#productBody").html(html)
                }
            })
        }

        function removeProduct(id) {

            if (confirm("确定删除该产品吗")) {
                $.ajax({
                    url: "workbench/category/removeProduct",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {

                            // 刷新关联的产品列表
                            showProductList()

                        } else {
                            alert("删除产品信息失败")
                        }
                    }
                })
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
        <h3>${category.name} <small><a href="javascript:void(0)" target="_blank">&nbsp;</a></small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">

    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">类别名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${category.name}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">类别特性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${category.features}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${category.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${category.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${category.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${category.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${category.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>


<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>产品列表</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>规格</td>
                    <td>单价</td>
                    <td>库存数量</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="productBody">

                </tbody>
            </table>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>