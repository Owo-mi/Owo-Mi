import * as package_1 from "../_dependencies/onchain/0x1/init";
import * as package_2 from "../_dependencies/onchain/0x2/init";
import * as package_711a02c4e2ba28fce3d9c095a259f622b0502bfc1b96e77b6c0dc136199729f from "../owo-mi-package/init";
import {structClassLoaderOnchain as structClassLoader} from "./loader";

let initialized = false; export function initLoaderIfNeeded() { if (initialized) { return }; initialized = true; package_1.registerClasses(structClassLoader);
package_2.registerClasses(structClassLoader);
package_711a02c4e2ba28fce3d9c095a259f622b0502bfc1b96e77b6c0dc136199729f.registerClasses(structClassLoader);
 }
