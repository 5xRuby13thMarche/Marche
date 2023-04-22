import {config, library, dom} from "@fortawesome/fontawesome-svg-core";

config.mutateApproach = "sync";

import {faHeart as regularHeart} from "@fortawesome/free-regular-svg-icons";
import {faHeart as solidHeart} from "@fortawesome/free-solid-svg-icons";

library.add(regularHeart);
library.add(solidHeart);

dom.watch();
