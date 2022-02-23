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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>


    <script type="text/javascript">

        var rsc_bs_pag = {
            go_to_page_title: 'Go to page',
            rows_per_page_title: 'Rows per page',
            current_page_label: 'Page',
            current_page_abbr_label: 'p.',
            total_pages_label: 'of',
            total_pages_abbr_label: '/',
            total_rows_label: 'of',
            rows_info_records: 'records',
            go_top_text: '首页',
            go_prev_text: '上一页',
            go_next_text: '下一页',
            go_last_text: '末页'
        };

        $(function () {

            pageList();

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            // 为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked)
            })

            $("#cartBody").on("click",$("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length==$("input[name=xz]:checked").length);
            })

            $("#addBtn").click(function () {

                var $xl = $("input[name=xz]:checked")

                var content = "";
                for (var i = 0; i < $xl.length; i++) {
                    var id = $($xl[i]).val()
                    content += "商品：" + $("#a" + id).html();
                    content += "\t\t购买数量：" + $("#b" + id).html();
                    content += "\t\t商品单价：" + $("#c" + id).html();
                    content += "\t\t单项总价：" + $("#d" + id).html();
                    // 如果不是最后一个元素, 需要在后面追加一个&符
                    if (i < $xl.length - 1) {
                        content += "\r\n";
                    }
                }
                $("#create-content").html(content)

                $("#createTransactionModal").modal("show")

            })

            $("#saveBtn").click(function () {

                var $xz = $("input[name=xz]:checked")

                var param = "";
                var orderPrice = 0;

                for (var i = 0; i < $xz.length; i++) {
                    param += "id=" + $($xz[i]).val() + "&";
                    orderPrice += parseInt($("#d"+$($xz[i]).val()).text());
                }
                param += "orderPrice=" + orderPrice + "&";
                param += "contactsPhone=" + $.trim($("#create-phone").val()) +"&";
                param += "orderDestination=" + $.trim($("#create-address").val());

                $.ajax({
                    url: "workbench/buyer/cart/generateOrder",
                    data: param,
                    dataType: "json",
                    success:function (data) {
                        if (data.success) {

                            alert("支付成功！")
                            pageList()
                            $("#createTransactionModal").modal("hide")
                        } else {
                            alert("支付失败！")
                        }
                    }
                })
            })
        });

        function pageList() {

            $.ajax({
                url: "workbench/buyer/cart/pageList",
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a id="a' + n.id + '" style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/buyer/shopping/detail?id=' + n.productId + '\';">' + n.goodsName + '</a></td>';
                        html += '<td id="b' + n.id + '">' + n.goodsNumber + '</td>';
                        html += '<td id="c' + n.id + '">' + n.goodsPrice + '</td>';
                        html += '<td id="d' + n.id + '">' + n.goodsAmount + '</td>';
                        html += '</tr>';
                    })

                    $("#cartBody").html(html);

                }
            })
        }
    </script>
</head>
<body>

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建交易</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="transactionAddForm" role="form">

                    <div class="form-group">
                        <label for="create-content" class="col-sm-2 control-label">商品信息&nbsp;&nbsp;</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="6" id="create-content" readonly></textarea>
                        </div>
                    </div>


                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>


                    <div class="form-group" style="position: relative;top: 20px;">
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

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>购物车列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" id="addBtn" class="btn btn-danger"><span class="glyphicon glyphicon-shopping-cart"></span> 创建交易</button>
            </div>

        </div>

        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>商品名称</td>
                    <td>购买数量</td>
                    <td>商品单价</td>
                    <td>商品总价</td>
                </tr>
                </thead>
                <tbody id="cartBody">

                </tbody>

            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="cartPage"></div>

        </div>

    </div>

</div>
</body>
</html>