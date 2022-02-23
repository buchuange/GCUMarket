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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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

        $(function () {

            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/transaction/getCustomerName",
                        { "name" : query },
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 800
            });

            pageList(1, 2);

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $("#openSearchModalBtn").click(function () {
                $("#searchProductModal").modal("show")
            })

            // 为搜索产品的输入框绑定键盘事件，当按下回车健时触发
            $("#pname").keydown(function (event) {
                if (event.keyCode == 13) {
                    $.ajax({
                        url: "workbench/transaction/getProductListByName",
                        data: {
                            "pname": $.trim($("#pname").val())
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data, function (i, n) {
                                html += '<tr>';
                                html += '<td><input type="checkbox" value="' + n.id + '" name="xl"/></td>';
                                html += '<td id="n' + n.id + '">' + n.name + '</td>';
                                html += '<td id="c' + n.id + '">' + n.categoryId + '</td>';
                                html += '<td id="i' + n.id + '">' + n.inventory + '</td>';
                                html += '<td><input  id="b' + n.id + '" type="text" style="width: 100px; text-align: center" onblur="modifyCount(\''+n.id+'\')" value="1"></td>';
                                html += '</tr>';

                            })
                            $("#productSearchBody").html(html)
                        }
                    })
                    return false;
                }
            })

            $("#commitProductBtn").click(function () {

                // 找到复选框中所有挑√的复选框的jquery对象
                var $xl = $("input[name=xl]:checked")

                if ($xl.length == 0) {
                    alert("请选择该客户所购买的产品")
                } else {
                    var param = "";
                    for (var i = 0; i < $xl.length; i++) {
                        var id = $($xl[i]).val()
                        param += "categoryName=" + $("#c" + id).html();
                        // 如果不是最后一个元素, 需要在后面追加一个&符
                        if (i < $xl.length - 1) {
                            param += "&";
                        }
                    }
                    $.ajax({
                        url: "workbench/transaction/isDuplicate",
                        data: param,
                        dataType: "json",
                        success: function (data) {
                            if (!data.success) {
                                var content = "";
                                for (var i = 0; i < $xl.length; i++) {
                                    var id = $($xl[i]).val()
                                    content += "产品：" + $("#n" + id).html();
                                    content += "\t\t购买数量：" + $("#b" + id).val();
                                    // 如果不是最后一个元素, 需要在后面追加一个&符
                                    if (i < $xl.length - 1) {
                                        content += "\r\n";
                                    }
                                }
                                $("#create-content").html(content)

                                $("#searchProductModal").modal("hide")
                            } else {
                                alert("同类产品在一张发票上只能出现一次!")
                            }
                        }
                    })
                }
            })

            // 为查询按钮绑定事件，执行查询操作，触发pageList()方法
            $("#searchBtn").click(function () {
                /*
                   点击查询按钮的时候，我们应该先将搜索框中的信息保存起来，保存到隐藏域中
                */
                $("#hidden-customerName").val($.trim($("#search-customerName").val()))
                $("#hidden-transactionName").val($.trim($("#search-transactionName").val()))

                pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            // 为保存按钮绑定事件，执行客户信息的添加操作
            $("#saveBtn").click(function () {

                var name = $.trim($("#create-name").val())
                var customerName = $.trim($("#create-customerName").val())
                var purchaseDate = $.trim($("#create-purchaseDate").val())
                var content = $.trim($("#create-content").val())
                var description = $.trim($("#create-description").val())

                if (name == "" || customerName == "" || purchaseDate == "" || content == "" || description == "") {
                    alert("请填写完整的信息")
                } else {
                    if (confirm("交易信息一旦生成不可更改，请仔细检查是否填写有误，是否提交？")) {
                        var $xl = $("input[name=xl]:checked")

                        var param = "name=" + name + "&";
                            param += "customerName=" + customerName + "&";
                            param += "purchaseDate=" + purchaseDate + "&";
                            param += "description=" + description + "&";

                        for (var i = 0; i < $xl.length; i++) {
                            var id = $($xl[i]).val()
                            param += "productId=" + id + "&";
                            param += "purchaseQuantity=" + $("#b" + id).val()
                            // 如果不是最后一个元素, 需要在后面追加一个&符
                            if (i < $xl.length - 1) {
                                param += "&";
                            }
                        }

                        $.ajax({
                            url: "workbench/transaction/save",
                            data: param,
                            dataType: "json",
                            success: function (data) {

                                if (data.success) {

                                    // 做完添加操作后，回到第一页，维持每页展现的记录数
                                    pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));

                                    // 清空添加操作模态窗口中的数据
                                    $("#transactionAddForm").get(0).reset()

                                    // 情况搜索产品模态框的数据
                                    $("#pname").val("")
                                    $("#productSearchBody").html("")
                                    $("#create-content").html("")
                                    // 关闭添加操作的模态窗口
                                    $("#createTransactionModal").modal("hide")
                                } else {
                                    alert("交易信息添加失败！")
                                }
                            }
                        })
                    }
                }
            })

            // 为搜索产品的模态框的全选复选框绑定事件，触发全选操作
            $("#as").click(function () {
                $("input[name=xl]").prop("checked", this.checked)
            })

            $("#productSearchBody").on("click",$("input[name=xl]"), function () {
                $("#as").prop("checked", $("input[name=xl]").length==$("input[name=xl]:checked").length);
            })


            // 为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked)
            })

            $("#transactionBody").on("click",$("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length==$("input[name=xz]:checked").length);
            })

            // 为删除按钮绑定事件，执行删除操作
            $("#deleteBtn").click(function () {

                // 找到复选框中所有挑√的复选框的jquery对象
                var $xz = $("input[name=xz]:checked")

                if ($xz.length == 0) {
                    alert("请选择要删除的交易信息")
                } else {
                    if (confirm("确定删除所选中的记录吗？")) {

                        var param = "";
                        for (var i = 0; i < $xz.length; i++) {
                            param += "id=" + $($xz[i]).val();

                            // 如果不是最后一个元素, 需要在后面追加一个&符
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }

                        $.ajax({
                            url: "workbench/transaction/delete",
                            data: param,
                            type: "post",
                            dataType: "json",
                            success: function (data) {

                                if (data.success) {
                                    // 回到第一页，维持每页展现的记录数
                                    pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("删除交易信息失败")
                                }
                            }
                        })
                    }
                }
            })

        });


        function pageList(pageNum, pageSize) {

            // 将全选的复选框的√干掉
            $("#qx").prop("checked", false);

            // 查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-transactionName").val($.trim($("#hidden-transactionName").val()))
            $("#search-customerName").val($.trim($("#hidden-customerName").val()))

            $.ajax({
                url: "workbench/transaction/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "transactionName": $.trim($("#search-transactionName").val()),
                    "customerName": $.trim($("#search-customerName").val())
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    // 每一个n就是每一个客户对象
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail?id=' + n.id + '\';">' + n.transactionName + '</a></td>';
                        html += '<td>' + n.customerName + '</td>';
                        html += '<td>' + n.purchaseDate + '</td>';
                        html += '</tr>';
                    })

                    $("#transactionBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#transactionPage").bs_pagination({
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

        function modifyCount(id) {
            // 输入的数据只能是1 ~ 库存数量,只要不是这个范围内的,归1
            var userInput = $.trim($("#b"+id).val()); // 用户输入的数据
            var inventory = parseInt($("#i"+id).text())  // 库存数量
            // 当这个数据不合法的时候归1
            if (parseInt(userInput) != userInput) {
                $("#b"+id).val("1")
            }
            // 第一个数字是1-9中的一个.第二个数字可以有也可以没有.
            var regExp = /^[1-9][0-9]*$/
            var ok = regExp.test(userInput)
            if (!ok) { //不符合正则
                $("#b"+id).val("1")
            } else {
                // 走到这里一定是数字,但是数字必须是1~库存
                if (userInput > inventory) {
                    $("#b"+id).val("1")
                }
            }
        }
    </script>
</head>
<body>

<input type="hidden" id="hidden-transactionName"/>
<input type="hidden" id="hidden-customerName"/>

<!-- 创建交易的模态窗口 -->
<div class="modal fade" id="createTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建交易</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="transactionAddForm" role="form">

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">交易名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                                    style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
                            </div>
                            <label for="create-purchaseDate" class="col-sm-2 control-label">购买日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-purchaseDate" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-content" class="col-sm-2 control-label">产品源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span
                                    class="glyphicon glyphicon-search"></span></a></label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-content" readonly></textarea>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-description"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 选择产品的模态窗口 -->
<div class="modal fade" id="searchProductModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索产品</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="pname" style="width: 300px;"
                                   placeholder="请输入产品名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="productTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="as"/></td>
                        <td>名称</td>
                        <td>类别</td>
                        <td>库存数量</td>
                        <td>购买数量</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="productSearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="commitProductBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">交易名称</div>
                        <input class="form-control" type="text" id="search-transactionName">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="search-customerName">
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
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createTransactionModal">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>交易名称</td>
                    <td>客户名称</td>
                    <td>购买日期</td>
                </tr>
                </thead>
                <tbody id="transactionBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="transactionPage"></div>

        </div>

    </div>

</div>
</body>
</html>