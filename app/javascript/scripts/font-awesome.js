import {config, library, dom} from "@fortawesome/fontawesome-svg-core";

config.mutateApproach = "sync";

import {faHeart as regularHeart} from "@fortawesome/free-regular-svg-icons";
import {faHeart as solidHeart} from "@fortawesome/free-solid-svg-icons";
import {faTrashCan} from "@fortawesome/free-regular-svg-icons";
import {faX} from "@fortawesome/free-solid-svg-icons";
import {faMagnifyingGlass} from "@fortawesome/free-solid-svg-icons";
import {faBackward} from "@fortawesome/free-solid-svg-icons";
import {faTruck} from "@fortawesome/free-solid-svg-icons";
import {faGithub} from '@fortawesome/free-brands-svg-icons'


library.add(regularHeart);
library.add(solidHeart);
library.add(faTrashCan);
library.add(faX);
library.add(faMagnifyingGlass);
library.add(faBackward);
library.add(faTruck);
library.add(faGithub)

dom.watch();
