$(function () {
    $("#dialog-confirm").dialog({
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: {
            "Sim": function () {
                $.ajax({
                    type: "POST",
                    url: "/Departamento/Delete",
                    data: { id: $("a.remove").attr("data-id") },
                    success: function (info) {
                        $("#dialog-confirm").dialog("close");
                        location.reload();
                    }
                });
            },
            Cancel: function () {
                $("a.remove").removeClass("remove");
                $("#dialog-confirm").dialog("close");
            }
        }
    });
    $("#dialog-confirm").dialog("close");
    $(".remover-item").on("click", function () {
        $(this).addClass("remove");
        $("#dialog-confirm").dialog("open");
    });
});