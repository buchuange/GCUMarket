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

            showRemarkList()
            showTransactionList();
        });

        function showTransactionList() {

            $.ajax({
                url: "workbench/business/product/showTransactionList",
                data: {
                    "productId" : "${product.id}"
                },
                dataType:"json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>'+n.buyerId+'</td>';
                        html += '<td>'+n.goodsNumber+'</td>';
                        html += '<td>'+n.goodsAmount+'</td>';
                        html += '<td>'+n.createTime+'</td>';
                        html += '</tr>';
                    })

                    $("#transactionBody").html(html)
                }
            })
        }

        function showRemarkList() {
            $.ajax({
                url: "workbench/business/product/getRemarkListByPId",
                data: {
                    "productId" : "${product.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;">';
                        html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
                        html += '<font color="gray">商品</font> <font color="gray">-</font><b>${product.name}</b> <small style="color: gray;" id="s'+n.id+'">'+ n.createTime+' 由'+n.createBy+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: block;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id +'\')"><span class="glyphicon glyphicon-remove"style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })

                    $("#remarkDiv").before(html)
                }
            })
        }


        function deleteRemark(id) {

            if (confirm("确定删除该条评论吗")) {
                $.ajax({
                    url: "workbench/business/product/deleteProductRemark",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {

                            // 删除备注成功
                            // 这种做法不行，记录使用的是before方法，每一次删除之后，页面上都会保留原有的数据
                            // showRemarkList()

                            // 找到需要删除记录的div,将div移除掉
                            $("#" + id).remove()
                        } else {
                            alert("删除评论失败")
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
        <h3>${product.name} <small><a href="javascript:void(0)" target="_blank">&nbsp;</a></small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">

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
        <div style="width: 300px;position: relative; left: 150px; top: -20px;"><b>${product.inventory}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">商品状态</div>
        <div style="width: 300px;position: relative; left: 600px; top: -60px;"><b>${product.status}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 50px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 150px; top: -20px;"><b>${product.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${product.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 50px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 150px; top: -20px;"><b>${product.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${product.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
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
                    <td>支付金额</td>
                    <td>购买日期</td>
                </tr>
                </thead>
                <tbody id="transactionBody">

                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>商品评价</h4>
    </div>

    <div id="remarkDiv">

    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>