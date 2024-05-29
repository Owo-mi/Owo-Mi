import * as fund from "./fund/structs";
import * as saving from "./saving/structs";
import {StructClassLoader} from "../_framework/loader";

export function registerClasses(loader: StructClassLoader) { loader.register(fund.Fund);
loader.register(fund.FundCap);
loader.register(saving.Saving);
loader.register(saving.SavingCap);
loader.register(saving.SavingTarget);
 }
