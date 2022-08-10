function accordionLabelClickedEventListener(event) {
    var labelElement = event.target;
    labelElement.classList.toggle("open");
    updateAccordionPanelFromLabel(labelElement);
}

function updateAccordionPanelFromLabel(labelElement) {
    if (labelElement) {
        var open = labelElement.classList.contains("open");
        var panelElement = labelElement.nextElementSibling;
        if (open) {
            panelElement.style.display = "block";
        }
        else {
            panelElement.style.display = "none";
        }
    }
}

$("document").ready(function () {

    var accordionLabels = $(".accordion-label");
    for (var i = 0; i < accordionLabels.length; i++) {
        accordionLabels[i].addEventListener("click", accordionLabelClickedEventListener);
        updateAccordionPanelFromLabel(accordionLabels[i]);
    }

});