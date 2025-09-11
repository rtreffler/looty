package looty.util

import scala.scalajs.js


//////////////////////////////////////////////////////////////
// Created by bjackman @ 12/10/13 9:33 PM
//////////////////////////////////////////////////////////////

object Optional {
  implicit class OptionalExtensions[A](val a: Optional[A]) extends AnyVal {
    def isNull = a == null
    def isUndefined = js.isUndefined(a)
    def isEmpty = isNull || isUndefined
    def nonEmpty = !isEmpty
    def get: A = if (nonEmpty) a.asInstanceOf[A] else sys.error(s"get called on nullable when A is not defined")
    def toOption: Option[A] = if (nonEmpty) Some(get) else None
  }
  implicit def AToOptional[A](a : A) = a.asInstanceOf[Optional[A]]
}

@js.native
trait Optional[+A] extends js.Object
