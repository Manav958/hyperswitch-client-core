open ReactNative
open Style

@react.component
let make = (~onModalClose, ~updateModalViewHeight) => {
  let (nativeProp, _) = React.useContext(NativePropContext.nativePropContext)
  let {iconColor} = ThemebasedStyle.useThemeBasedStyle()
  let (paymentScreenType, _) = React.useContext(PaymentScreenContext.paymentScreenTypeContext)
  let (savedPaymentMethodContextObj, _) = React.useContext(
    SavedPaymentMethodContext.savedPaymentMethodContext,
  )

  let isLoadingScreenActive = switch savedPaymentMethodContextObj {
  | Loading => true
  | _ => false
  }

  <View
    onLayout=updateModalViewHeight
    style={viewStyle(
      ~display=#flex,
      ~flexDirection=#row,
      ~alignItems=#center,
      ~justifyContent=#"space-between",
      ~margin=5.->pct,
      ~marginBottom=0.->pct,
      (),
    )}>
    {if savedPaymentMethodContextObj == Loading {
      React.null
    } else {
      switch switch paymentScreenType {
      | PaymentScreenContext.PAYMENTSHEET => nativeProp.configuration.paymentSheetHeaderText
      | PaymentScreenContext.SAVEDCARDSCREEN =>
        nativeProp.configuration.savedPaymentScreenHeaderText
      } {
      | Some(var) =>
        <View style={viewStyle(~maxWidth=60.->pct, ())}>
          <TextWrapper text={var} textType={HeadingBold} />
        </View>
      | _ => React.null
      }
    }}
    <View
      style={viewStyle(
        ~flexDirection=#row,
        ~flexWrap=#wrap,
        ~alignItems=#center,
        ~maxWidth=40.->pct,
        (),
      )}>
      {isLoadingScreenActive
        ? React.null
        : <>
            {nativeProp.env === GlobalVars.PROD
              ? React.null
              : <View
                  style={viewStyle(
                    ~backgroundColor="#ffdd93",
                    ~marginHorizontal=5.->dp,
                    ~padding=5.->dp,
                    ~borderRadius=5.,
                    (),
                  )}>
                  <TextWrapper
                    textType={ModalTextBold}
                    text="Test Mode"
                    overrideStyle=Some(textStyle(~color="black", ()))
                  />
                </View>}
            <TouchableOpacity onPress={_ => onModalClose()}>
              <Icon name="close" width=16. height=16. fill=iconColor />
            </TouchableOpacity>
          </>}
    </View>
  </View>
}
