import { App, Widget } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"
import MprisPlayers from "./media-player/MediaPlayer"

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
        new Widget.Window({}, MprisPlayers())
    },
})
