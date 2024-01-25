let intervalTimer = 121;
let calTimer = 1;

setInterval(function () {
  if (intervalTimer == 0) {
    intervalTimer = 120;
    const minutes = Math.floor(intervalTimer / 60);
    const seconds = intervalTimer % 60;
    const resultTime = minutes + " Minute(s)" + seconds + " Sec(s)";
    $actions.IncreaseTimer(resultTime);
    $actions.RefresUserMark();
  } else {
    intervalTimer -= calTimer;
    const minutes = Math.floor(intervalTimer / 60);
    const seconds = intervalTimer % 60;
    const resultTime = minutes + " Minute(s)" + seconds + " Sec(s)";
    $actions.IncreaseTimer(resultTime);
  }
}, 1000);

If(
  (DisplayText = "NEW"),
  Entities.Color.Indigo,
  If(
    (DisplayText = "WAITING FOR TPAS" or DisplayText = "WAITING CLAIM INFORMATION" or DisplayText = "WAITING INVESTIGATION BY FMC"),
    Entities.Color.Violet,
    If(
      (DisplayText = "ASSIGNED" or DisplayText = "WAITING NOP MGR APPROVAL" or DisplayText = "WAITING NOS MGR APPROVAL"),
      Entities.Color.Grape,
      If(
        (DisplayText = "IN PROGRESS" or DisplayText = "WAITING BAIV NOP" or DisplayText = "WAITING DAISY SPPH NOS"),
        Entities.Color.Pink,
        If(
          (DisplayText = "WAITING PRICE NEGOTIATION FMC" or DisplayText = "UNDER REVIEW BOQ NOS"),
          Entities.Color.Teal,
          If(
            (DisplayText = "SUBMITTED" or DisplayText = "COMPLETED"),
            Entities.Color.Red,
            If(
              (DisplayText = "CLOSED"),
              Entities.Color.Violet,
              If(
                (DisplayText = "REJECTED"),
                Entities.Color.Grape,
                If(
                  (DisplayText = "APPROVED"),
                  Entities.Color.Green,
                  If(
                    (DisplayText = "TAKEOUT"),
                    Entities.Color.Pink,
                    Entities.Color.Neutral5
                  )
                )
              )
            )
          )
        )
      )
    )
  )
);
