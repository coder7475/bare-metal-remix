import { getModelForClass, prop } from "@typegoose/typegoose";

class KittenClass {
  @prop()
  public name?: string;
}

export const KittenModel = getModelForClass(KittenClass);
