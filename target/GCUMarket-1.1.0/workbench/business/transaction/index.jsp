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

            pageList(1, 4);

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $("#searchBtn").click(function () {
                /*
                   点击查询按钮的时候，我们应该先将搜索框中的信息保存起来，保存到隐藏域中
                */
                $("#hidden-goodsName").val($.trim($("#search-goodsName").val()))

                pageList(1, $("#salePage").bs_pagination('getOption', 'rowsPerPage'));
            })

            $("#saveBtn").click(function () {

                $.ajax({
                    url: "workbench/business/transaction/deliverGoods",
                    data: {
                        "id": $("#hidden-id").val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("发货成功")
                            pageList($("#salePage").bs_pagination('getOption', 'currentPage')
                                ,$("#salePage").bs_pagination('getOption', 'rowsPerPage'));

                            $("#addDeliverModal").modal("hide")
                        }
                    }
                })
            })


        });

        function addDeliverModal(orderNumber, id) {

            $("#hidden-id").val(id)

            $.ajax({
                url: "workbench/business/transaction/getInfo",
                data: {
                    "orderNumber": orderNumber
                },
                dataType: "json",
                success: function (n) {
                    $("#create-orderNumber").val(n.orderNumber)
                    $("#create-contacts").val(n.buyerId)
                    $("#create-phone").val(n.contactsPhone)
                    $("#create-address").val(n.orderDestination)

                    $("#addDeliverModal").modal("show")
                }
            })
        }

        function pageList(pageNum, pageSize) {

            $("#search-goodsName").val($.trim($("#hidden-goodsName").val()))

            $.ajax({
                url: "workbench/business/transaction/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "businessId": "${user.id}",
                    "goodsName": $.trim($("#search-goodsName").val())
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td>'+(i+1)+'</td>';
                        html += '<td>' + n.goodsName + '</td>';
                        html += '<td>' + n.goodsNumber + '</td>';
                        html += '<td>' + n.goodsPrice + '</td>';
                        html += '<td>' + n.goodsAmount + '</td>';
                        if (n.deliveryStatus == '4') {
                            html += '<td>交易取消</td>';
                            html += '<td></td>'
                        } else if (n.deliveryStatus == '0') {
                            html += '<td>待发货</td>';
                            html += '<td><a class="myHref" href="javascript:void(0);" onclick="addDeliverModal(\''+n.orderNumber+'\',+\''+n.id+'\')"><span class="glyphicon glyphicon-list-alt"style="font-size: 20px; color: #f0ad4e;"></span></a></td>';
                        } else if(n.deliveryStatus == '1') {
                            html += '<td>物流配送中，等待买家收货</td>';
                            html += '<td></td>'
                        } else {
                            html += '<td>已完成</td>';
                            html += '<td></td>'
                        }
                        html += '</tr>';
                    })

                    $("#saleBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#salePage").bs_pagination({
                        currentPage: pageNum, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数
                        visiblePageLinks: 3, // 显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        // 该回调函数是在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            })
        }
    </script>
</head>
<body>

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="addDeliverModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">订单信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="transactionAddForm" role="form">

                    <div class="form-group">
                        <label for="create-orderNumber" class="col-sm-2 control-label">订单号&nbsp;&nbsp;<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-orderNumber" readonly>
                        </div>
                    </div>


                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <input type="hidden" id="hidden-id"/>

                    <div class="form-group" style="position: relative;top: 20px;">
                        <label for="create-contacts" class="col-sm-2 control-label">联系人<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-contacts" readonly>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>


                    <div class="form-group" style="position: relative;top: 20px;">
                        <label for="create-phone" class="col-sm-2 control-label">联系电话<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" readonly>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">收获地址
                                <span style="font-size: 15px; color: red;">*</span>
                            </label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address" readonly></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">确定发货</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>销售列表</h3>
        </div>
    </div>
</div>

<input type="hidden" id="hidden-goodsName"/>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">商品名称</div>
                        <input class="form-control" type="text" placeholder="请输入商品名称" id="search-goodsName">
                    </div>
                </div>

                <div class="form-group">
                    <span>
                        <button type="button" class="btn btn-default" style="margin-left: 10px" id="searchBtn">
                            <span class="glyphicon glyphicon-search"></span> 查询
                        </button>
                    </span>
                </div>
            </form>
        </div>

        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>#</td>
                    <td>商品名称</td>
                    <td>购买数量</td>
                    <td>商品单价</td>
                    <td>商品总价</td>
                    <td>状态</td>
                    <td>操作</td>
                </tr>
                </thead>
                <tbody id="saleBody">

                </tbody>

            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="salePage"></div>

        </div>

    </div>

</div>
</body>
</html>