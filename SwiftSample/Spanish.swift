//
//  Spanish.swift
//  Makent
//
//  Created by trioangle on 08/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class Spanish : LanguageProtocol{
   
    
    lazy var authenticationIsNeeded: String = { return "Se necesita autenticación"}()
    lazy var pleaseSelectTheStartTime : String = {return "Por favor seleccione la hora de inicio"}()
    lazy var pleaseSelectTheEndTime : String = {return "Por favor seleccione la hora de finalización"}()
    lazy var endTimeShouldBeGreaterThanTheStartTime : String = {return "El tiempo final debe ser mayor que la hora de inicio."}()
    lazy var pleaseEnterCardNumber : String = {return "Por favor ingrese el número de la tarjeta"}()
    lazy var pleaseEnterExpirationDate : String = {return "Por favor ingrese la fecha de vencimiento"}()
    lazy var pleaseEnterCvcNumber : String = {return "Por favor ingrese el número de CVC"}()
    lazy var pleaseEnterFirstName : String = {return "Por favor ingrese el nombre"}()
    lazy var pleaseEnterLastName : String = {return "Por favor ingrese el apellido"}()
    lazy var pleaseEnterPostCode : String = {return "Por favor ingrese el código postal"}()
    lazy var serverErrorPleaseTryAgain : String = {return "Error del servidor Por favor, inténtalo de nuevo!"}()
    lazy var pleaseFillAllMandatory : String = {return "Por favor llene todo lo obligatorio"}()
    lazy var pleaseProvideYourSpaceIsFurnishedOrNot : String = {return "Por favor, proporcione su espacio está amueblado o no"}()
    lazy var pleaseEnterOrAddWorkStationValue : String = {return "Por favor ingrese o agregue valor de la estación de trabajo"}()
    lazy var pleaseSelectSharedOrPrivate : String = {return "Por favor, seleccione Compartido o Privado"}()
    lazy var pleaseProvideAreYouRentingNewOrExperience : String = {return "Por favor, proporcione su alquiler de nuevos o experimentados."}()
    lazy var selectedSpaceTypeIsDeActivatedByAdmin : String = {return "El tipo de espacio seleccionado está desactivado por admin"}()
    lazy var pleaseEnterSpaceAddress : String = {return "Por favor ingrese la dirección del espacio"}()
    lazy var pleaseEnterValidAddress : String = {return "Por favor ingrese la dirección válida"}()
    lazy var pleaseFillMandatoryFields : String = {return "Por favor llene los campos obligatorios"}()
    lazy var pleaseEnterListName : String = {return "Por favor ingrese el nombre de la lista"}()
    lazy var pleaseEnterSummary : String = {return "Por favor ingrese el resumen"}()
    lazy var pleaseEnterGuestCount : String = {return "Por favor ingrese el conteo de invitados"}()
    lazy var pleaseSelectStartAndEndTime : String = {return "Por favor, seleccione la hora de inicio y finalización"}()
    lazy var pleaseSelectStartTime : String = {return "Por favor seleccione la hora de inicio"}()
    lazy var pleaseSelectEndTime : String = {return "Por favor, seleccione la hora del final"}()
    lazy var pleaseSelectAtleastOneActivityFromList : String = {return "Por favor seleccione al menos una actividad de la lista"}()
    lazy var pleaseFillAllFields : String = {return "Por favor llena todos los espacios"}()
    lazy var preAccepted : String = {return "Previamente aceptado"}()
    lazy var pleaseEnterHourlyAmountGreaterThanOrEqualMinimumAmount : String = {return "Por favor, ingrese la cantidad por hora mayor o la cantidad mínima igual"}()
    lazy var pleaseEnterFullDayAmountGreaterThanHourlyAmount : String = {return "Por favor ingrese la cantidad total de día mayor que la cantidad por hora"}()
    lazy var pleaseEnterWeeklyAmountGreaterThanFullDayAmount : String = {return "Por favor ingrese la cantidad semanal mayor que la cantidad de día completo"}()
    lazy var pleaseEnterMonthlyAmountGreaterThanWeeklyAmount : String = {return "Por favor ingrese la cantidad mensual mayor que la cantidad semanal"}()
    lazy var minimumHourRange : String = {return "Rango de hora mínimo"}()
    lazy var pleaseChooseValidTimes : String = {return "Por favor, elija tiempos válidos"}()
    lazy var youCannotSelectThisTimeBecauseTimeIntervalIsAHourRequired : String = {return "No puede seleccionar esta vez porque el intervalo de tiempo se requiere una hora"}()
    lazy var pleaseSelectAddressFromList : String = {return "Por favor, seleccione la dirección de la lista"}()
    lazy var applyCoupon : String = {return "Aplicar cupón"}()
    lazy var coupon : String = {return "Cupón"}()
    lazy var removeCoupon : String = {return "Quitar el cupón"}()
    
    lazy var price_title : String = { return "Precio"}()
    lazy var people_title : String = { return "Personas"}()
    lazy var check_inTitle : String = { return "Hora de entrada"}()
    lazy var check_outTitle : String = { return "Hora de salida"}()
    lazy var yourReserv_Title : String = { return "Tu reservacion"}()
    lazy var wishList_Title : String = { return "Lista de deseos"}()
    lazy var booking_Title : String = { return "reservas"}()
    lazy var birth_Desc : String = { return "Usted debe ser al menos 18 años para utilizar"}()
    lazy var prepproved_Title : String = { return "Pre aprobado"}()
    lazy var whatill_Title: String = {return "Lo que proporcionaré"}()
    
    lazy var date: String = {return "fechas"}()
    lazy var hom_Titt : String = { return "Permanecer"}()
    lazy var Exp_Titt : String = { return "Experiencia"}()
    lazy var ExploreMakentSpace: String = {return "Explorar Spaciko"}()
    lazy var per_Hours: String = {return "per hour"}()
    lazy var guests : String = { return "Guests"}()
    lazy var filter : String = { return "Filter"}()
    lazy var showAll : String = { return "Show All"}()
    lazy var curLaneng : String = { return "Inglés"}()
    lazy var curLanarb : String = { return "Arábica"}()
    lazy var curLanspn : String = { return "Español"}()
    lazy var chsLan : String = { return "Elige lengua"}()
    lazy var categories : String = { return "Categories"}()
    lazy var guestTitle : String = { return "Guest"}()
    lazy var maximumGuestTitle : String = { return "Maximum guest count within"}()
    lazy var selected_Dates : String = {return "Select Dates"}()
    lazy var selected_Timings : String = {return "Select Timings"}()
    lazy var chooseTiming : String = { return "Choose Timing"}()
    lazy var noMoreDatas : String = { "No hay más datos disponibles para mostrar" }()
    
    //Contact Host Vc
    lazy var addStr: String = { return "Añadir"}()
    
    lazy var AppName : String = {return ""}()
    lazy var Homes: String = { return "Corsé"}()
    lazy var Experiences: String = {return "Experiencias"}()
    
    //ReviewsPageController
    lazy var reviews_Title: String = {return "Comentarios"}()
    
    //ExBookingController
    lazy var steps_LeftTitle: String = {return "pasos a la izquierda"}()
    lazy var step_LeftTitle : String = { return "paso pie izquierdo"}()
    lazy var network_ErrorIssue: String = {return "Problema del servidor. Vuelve a intentarlo."}()
    lazy var book_Title : String = {return "Reservar ahora"}()
    lazy var hours_Tit : String = {return "Horas"}()
    lazy var continue_Title: String = {return "Continuar"}()
    lazy var read_Title: String = {return "Leer"}()
    lazy var agreed_Title: String = {return "Convenido"}()
    lazy var other_Title : String = {return "Otro"}()
    lazy var host_ByTitle: String = {return "anfitrión por"}()
    lazy var lblTotalExText: String = { return "Total"}()
    lazy var eventType : String = { return "Event Type"}()

    /// similarList Details
    lazy var hourly_Rate: String = {return "Hourly Rate"}()
    lazy var full_Day_Rate: String = {return "Full Day Price"}()
    lazy var minimum_Booking_Hours: String = {return "Minimum Booking Hours"}()
    
    //IGCommon
    lazy var could_LoadTitle: String = {return "No se pudo cargar la vista con el tipo"}()
    
    //GuestPageCellTypeB -- TTTAttributedLabel
    lazy var agree_GuestPage: String = {return "Al reservar, acepta hacer Términos de servicio adicionales, Liberación y exención de invitados, y Política de cancelación"}()
    lazy var termsserv_Title: String = {return "términos de servicio"}()
    lazy var mak_AddTerms: String = {return "Makent Términos de servicio adicionales"}()
    lazy var guestrefund_Title: String = {return "reembolso de invitado"}()
    
    //WhosComingViewController
    lazy var who_ComingTitle: String = {return "¿Quién esta viniendo?"}()
    lazy var guest_Title: String = {return "Huésped"}()
    
    //AddGuestController
    lazy var addguest_Title: String = {return "Mantenga a sus invitados informados. Agregue su correo electrónico y les enviaremos el itinerario."}()
    lazy var done_Title: String = {return "Hecho"}()
    lazy var first_NameError: String = {return "Nombre no puede estar vacío"}()
    lazy var last_NameError: String = {return "El apellido no puede estar vacío"}()
    lazy var email_Error : String = {return "Ingrese su correo electrónico correcto"}()
    lazy var want_DeleteAlert: String = {return "¿Seguro que quieres eliminar?"}()
    lazy var cancel_Title: String = {return "Cancelar"}()
    lazy var delete_Title: String = {return "Borrar"}()
    lazy var ok_Title: String = {return "Okay"}()
    lazy var notmatch_Enum: String = {return "No coincide con Enum"}()
    
    //GroupSizeInfoController
    lazy var group_Title: String = {return "Tamaño del grupo"}()
    lazy var thereare_Title: String = {return "Existen"}()
    lazy var spotexp_Available: String = {return "lugares disponibles en esta experiencia."}()
    lazy var groupview_DontFill: String = {return "No tienes que llenarlos todos. Las experiencias están destinadas a ser sociales, por lo que otros invitados también pueden unirse"}()
    lazy var grpsize_Content: String = { return "Usted no tiene que llenar todos ellos. Experiencias están destinados a ser social, para otros viajeros podrían unirse también"}()
    
    //GuestRequirementController
    lazy var guestreq_Title: String = {return "Requisitos del huésped"}()
    
    //ReviewGuestRequirementsController
    lazy var guestRequire_Title: String = {return "Revisar los requisitos del huésped"}()
    
    //EventCancellationPolicyController
    lazy var weather_Title: String = {return "Clima"}()
    lazy var accountVerifi_Title: String = {return "Verificación de la cuenta"}()
    lazy var makhostexpeve_Cancel : String = {return "Makent Hosts \nExperiencia y evento \nPolítica de cancelación"}()
    lazy var general_Cancel : String = {return "Cancelación general"}()
    lazy var hrs24_Refund : String = {return "Cualquier experiencia o evento, cancelado dentro de las 24 horas de la reserva, es elegible para un reembolso completo."}()
    lazy var event30_Day : String = {return "Cualquier cancelación de experiencia o evento que sea 30 días o más antes de la fecha de inicio, es elegible para un reembolso completo."}()
    lazy var cancel30_Day : String = {return "Las cancelaciones con menos de 30 días antes de la fecha de inicio no serán elegibles para un reembolso, a menos que su lugar sea reservado y completado por otro huésped."}()
    lazy var days14_Refund : String = {return "En caso de que otro huésped reserve y complete su lugar, se procesará un reembolso completo dentro de los 14 días posteriores a la fecha de inicio de la experiencia."}()
    lazy var cancel_Reason : String = {return "Sin embargo, si el motivo de la cancelación cumple con la política de circunstancias atenuantes, se le reembolsará en su totalidad."}()
    lazy var account_Verif : String = {return "Si algún miembro de su grupo no puede completar el proceso de verificación de la cuenta dentro de los 3 días posteriores a la compra, todas las partes y lugares para la experiencia o evento serán cancelados y reembolsados ​​por completo."}()
    lazy var hostoffr_Msg : String = {return "Los anfitriones hacen todo lo posible para continuar, según lo programado, con experiencia o eventos. Si las malas condiciones climáticas crean un escenario inseguro para los huéspedes o anfitriones, el resultado puede ser un cambio o la cancelación parcial de un itinerario o actividad. En caso de que el anfitrión o invitado cancele una experiencia o evento individual, o si un itinerario cambia sustancialmente o da como resultado el cese del viaje, Makent trabajará con su anfitrión para proporcionar un reembolso apropiado. Para solicitar oficialmente la cancelación de su experiencia o evento, contáctenos."}()
    
    //ExRoomDetailCell
    lazy var hours_Total: String = {return "horas totales"}()
    lazy var offer_In: String = {return "Ofrecido en"}()
    lazy var exp_Title: String = {return "experiencia"}()
    lazy var total_Hours: String = {return "Total Hours"}()
    lazy var choose_your_country = {return "Choose your country"}()
    lazy var request_book = {return "Request to Book"}()
    lazy var instant_book = {return "Instant Book"}()
    //CancelRequestVC
    lazy var canres_Tit : String = {return "Cancelar esta reserva"}()
    lazy var can_Reser : String = {return "Cancelar mi reserva"}()
    
    //ReservationDetailVC
    lazy var whycancel_Tit :String = {return "¿Por qué estás cancelando?"}()
    lazy var mypla_Long :String = {return "Mi lugar ya está disponible"}()
    lazy var wntoff_List :String = {return "Quiero ofrecer una lista diferente o cambiar el precio"}()
    lazy var need_Maintain :String = {return "Mi lugar necesita mantenimiento"}()
    lazy var exten_Circum :String = {return "Tengo una circunstancia atenuante"}()
    lazy var gues_Cancel :String = {return "Mi invitado necesita cancelar"}()
    lazy var why_Dec :String = {return "¿Por qué estás disminuyendo?"}()
    lazy var errorinCancel: String = { return "Introduzca la razón válida"}()
    lazy var date_Avail :String = {return "Las fechas no están disponibles."}()
    lazy var notfeel_Comfort :String = {return "No me siento cómodo con este invitado"}()
    lazy var list_NotGood :String = {return "Mi listado no es bueno para las necesidades del huésped (niños, mascotas, etc.)"}()
    lazy var wait_Attract :String = {return "Estoy esperando una reserva más atractiva."}()
    lazy var ask_Diff :String = {return "El invitado solicita fechas diferentes a las seleccionadas en esta solicitud"}()
    lazy var msg_Spam :String = {return "Este mensaje es spam"}()
    lazy var nolong_Accom : String = {return "Ya no necesito acomodaciones"}()
    lazy var mytrav_Dat : String = {return "Mis fechas de viaje cambiaron"}()
    lazy var res_Acc : String = {return "Hice la reserva por accidente."}()
    lazy var hos_Cancel : String = {return "Mi anfitrión necesita cancelar"}()
    lazy var uncomfor_Host : String = {return "Me siento incómodo con el anfitrión"}()
    lazy var plc_Expect : String  = {return "El lugar no es lo que esperaba"}()
    
    //AddPhotoVC
    lazy var edt_Title : String = {return "Editar"}()
    
    //Pre-AcceptVC
    lazy var preacc_Req : String = {return "Pre-Aceptar esta solicitud"}()
    lazy var opt_Msg : String = {return "Escriba mensaje opcional para invitado ..."}()
    
    //ExperienceDetailsController
    lazy var meethost_Title: String = {return "Conoce a tu anfitrión"}()
    lazy var addanogues_Title : String = {return "Agregar otro invitado"}()
    lazy var whatwldo_Title: String = {return "Que haremos"}()
    
    lazy var whatwdo_Title: String = {return "Lo que proporcionaremos"}()
    lazy var notes_Title: String = {return "Notas"}()
    lazy var whocom_Title: String = {return "Quien puede venir"}()
    lazy var whrwlbe_Title: String = {return "Donde estaremos"}()
    lazy var grpsiz_Title: String = {return "Tamaño del grupo hasta"}()
    lazy var expcan_Policy: String = {return "Experiencia política de cancelación"}()
    lazy var conthost_Title: String = {return "Contactar al anfitrión"}()
    lazy var insbook_Title: String = {return "Libro instantáneo"}()
    lazy var reqbook_Title: String = {return "Solicitud de reserva"}()
    lazy var checkout_Awesom: String = {return "Echa un vistazo a esta increíble casa en"}()
    lazy var rev_Title: String = {return "revisión"}()
    lazy var revs_Title: String = {return "Comentarios"}()
    lazy var seedates_Title: String = {return "Ver fechas"}()
    lazy var perpers_Title: String = {return "por persona"}()
    lazy var whatiprov_Title : String = {return "lo que proporciono"}()
    //ExMeetYourHostCell attributed  ..Read More
    
    //ExContactHostController
    lazy var contreq_Send: String = {return "La solicitud de contacto ha enviado a"}()
    lazy var need_More: String = {return "Necesita más información sobre la caminata digna de Instagram en"}()
    lazy var write_Mess: String = {return "Escribe un mensaje..."}()
    
    //ContactHostTypeACell -- TTTAttributedLabel
    lazy var faq_Msg : String = {return "Si tiene preguntas generales sobre cómo funciona la experiencia, visite o FAQ"}()
    lazy var faq_Title : String = {return "visita o preguntas frecuentes"}()
    lazy var date_Req: String = { return "Se requiere el registro de entrada Fecha"}()
    
    //ExperienceCalenderController
    lazy var sel_MulDat: String = {return "Seleccionar varias fechas"}()
    lazy var whrlik_Msg : String = {return "Cuando te gustaría ir ?"}()
    lazy var choos_Tit : String = {return "Escoger"}()
    lazy var perprsn_Tit : String = {return "por persona"}()
    lazy var sun_Title: String = {return "domingo"}()
    lazy var mon_Title: String = {return "lunes"}()
    lazy var tue_Title: String = {return "martes"}()
    lazy var wed_Title: String = {return "miércoles"}()
    lazy var thurs_Title: String = {return "jueves"}()
    lazy var fri_Title: String = {return "viernes"}()
    lazy var sat_Title: String = {return "sábado"}()
    lazy var date_Error: String = {return "La fecha debe ser una fecha posterior a hoy."}()
    
    //ExCellMapHolderView
    lazy var wher_wlmeet: String = {return "ExCellMapHolderView"}()
    
    //CategorySelectionController
    lazy var sel_cats: String = {return "Seleccionar categorías"}()
    
    //SplashVC
    lazy var switch_Travel: String = {return "Cambiar a viajar"}()
    lazy var switch_Host: String =  {return "Cambiar a Hosting"}()
    lazy var reser_Title: String = {return "RESERVAS"}()
    lazy var cal_Title: String = {return "CALENDARIO"}()
    lazy var list_Title: String = {return "LISTADO"}()
    lazy var prof_Title: String = {return "PERFIL"}()
    lazy var expl_Title: String = {return "Explorar"}()
    lazy var save_Title: String = {return "Salvado"}()
    lazy var trip_Title: String = {return "Excursiones"}()
    lazy var inbox_Title: String = {return "Bandeja de entrada"}()
    lazy var profl_Title: String = {return "Perfil"}()
    lazy var login_Title: String = {return "iniciar sesión"}()
    
    
    
    //ForgotPassword
    lazy var forpass_Tit : String = {return "¿Olvidaste tu contraseña?"}()
    lazy var emailadd_Tit : String = {return "DIRECCIÓN DE CORREO ELECTRÓNICO"}()
    lazy var enter_Email : String = {return "Ingrese su correo electrónico para encontrar su cuenta."}()
    
    //SignUpVC
    lazy var wht_Name : String = {return "¿Cuál es tu nombre?"}()
    lazy var frstname_Tit : String = {return "PRIMER NOMBRE"}()
    lazy var lstname_Tit : String = {return "APELLIDO"}()
    
    //SignUpEmail
    lazy var yremail_Tit : String = {return "¿Y tu correo electrónico?"}()
    
    //SignUpPassword
    lazy var shw_Tit : String = {return "mostrar"}()
    lazy var emp_Pass : String = { return "Por favor, ingrese contraseña"}()
    lazy var eight_Pass : String = { return "La contraseña debe contener 8 caracteres"}()
    lazy var crt_Pass : String = {return "Crea una contraseña"}()
    lazy var pas_Tit : String = {return "CONTRASEÑA"}()
    
    //SignUpDOB
    lazy var whn_Bith : String = {return "¿Cuando es tu cumpleaños?"}()
    lazy var birth_Tit : String = {return "CUMPLEAÑOS"}()
    
    //MLImagePickerController
    lazy var allphoto_Title : String = {return "Todas las fotos"}()
    lazy var back_Title: String = {return "atrás"}()
    lazy var add_Title: String = {return "Añadir"}()
    lazy var photoexeed_Title: String = {return "Elige una foto que no se pueda exceder"}()
    
    //LoadWebView
    lazy var pay_Succes : String = {return "Pago pagado exitosamente"}()
    lazy var prepy_Succes : String = {return "Los datos de prepago se enumeran correctamente"}()
    lazy var paymnt_Succes : String = {return "El pago se ha completado con éxito."}()
    
    //MainVC
    lazy var bysign_Agree : String = {return "Al registrarme, acepto"}()
    lazy var lugg_Terms : String = {return "Términos de servicio de Luggaru, Política de privacidad, Política de reembolso de invitados, Términos de la garantía del anfitrión"}()
    lazy var welcm_To : String = {return "Bienvenue à"}()
    lazy var conti_Fb : String = { return "Continuar con Facebook"}()
    lazy var login_Tittle : String = { return "Iniciar sesión"}()
    lazy var conti_Google : String = { return "Continuar con Google"}()
    lazy var crt_Acc : String = { return "Crear una cuenta"}()
    lazy var confb_Title: String = {return "Conéctate con Facebook"}()
    lazy var postals_Tit : String = {return "postales"}()
    lazy var forg_Tit : String = {return "¿Se te olvidó tu contraseña?"}()
    lazy var dont_Acc : String = {return "¿Aún no tienes cuenta?"}()
    lazy var regishere_Title : String = {return "Registrar aquí"}()
    lazy var orr_Title : String = {return "O"}()
    lazy var congoog_Title: String = {return "Inicia sesión con Google"}()
    lazy var somemp_Title : String = {return "¡Algunos campos están vacíos!"}()
    lazy var crctval_Title : String = {return "Por favor, introduzca el valor correcto"}()
    lazy var errcongoog_Title : String = {return "Error al configurar los servicios de Google:"}()
    lazy var email_Title: String = {return "correo electrónico"}()
    lazy var pass_Title: String = {return "Contraseña"}()
    
    //SignUpPassword
    lazy var show_Title: String = {return "mostrar"}()
    lazy var hide_Title: String = {return "Esconder"}()
    
    //SignUpDOB
    lazy var signuppass_Title : String = {return "Contraseña de registro"}()
    lazy var otherppl_Title : String = {return "Otras personas no verán tu cumpleaños"}()
    
    //ForgotPassVC
    lazy var checkem_Title: String = {return "Consultar su correo electrónico"}()
    lazy var wesen_Email: String = {return "Enviamos un correo electrónico a"}()
    lazy var tap_Link: String = {return "Toque el enlace en ese correo electrónico para restablecer su contraseña."}()
    lazy var acc_Title: String = {return "Cuentas"}()
    lazy var pls_Log: String = {return "Inicie sesión en una cuenta de Facebook para compartir."}()
    lazy var email_NotSend: String = {return "No se pudo enviar el correo electrónico"}()
    lazy var email_NotSendMsg: String = {return "nuestro dispositivo no pudo enviar correos electrónicos. Verifique la configuración del correo electrónico e intente nuevamente."}()
    lazy var sprd_Msg: String = {return "Difunde las palabras del señor compartiendo esto"}()
    lazy var holy_Title: String = {return "Santo"}()
    lazy var offline_Title: String = {return "Desconectado V1.0"}()
    
    //TripsVC
    lazy var Trips_Msg1 : String = {return "¿Cuál será tu primera aventura?"}()
    lazy var Trips_Msg2 : String = {return "Encontrarás los itinerarios de tu viaje aquí."}()
    lazy var pend_Trip : String = {return "Viajes pendientes"}()
    lazy var upcom_Trip : String = {return "Viajes próximos"}()
    lazy var prev_Trip : String = {return "Viajes anteriores"}()
    lazy var curren_Trip : String = {return "Viajes actuales"}()
    
    //TripsDetailVC
    lazy var inq_Title : String = {return "Investigación"}()
    
    lazy var canld_Tit : String = {return "Cancelado"}()
    lazy var decld_Tit : String = {return "Rechazado"}()
    lazy var exp_Tit : String = {return "Muerto"}()
    lazy var accep_Tit : String = {return "Aceptado"}()
    lazy var preaccep_Tit : String = {return "Pre-aceptado"}()
    lazy var pend_Tit : String = {return "Pendiente"}()
    
    //ExploreVC
    lazy var inter_Error: String = {return "Por favor revise su conexion a internet"}()
    lazy var pullref_Title: String = {return "Tire para actualizar"}()
    lazy var anytime_Title: String = {return "En cualquier momento"}()
    lazy var anywhere_Title: String = {return "En cualquier sitio"}()
    lazy var nomore_DataErr: String = {return "No hay más datos disponibles...."}()
    lazy var unexp_KindErr: String = {return "Tipo de elemento inesperado"}()
    lazy var opentim_Title: String = {return "Tiempo abierto"}()
    lazy var clstim_Title: String = {return "Hora de cierre"}()
    lazy var retry_Title: String = {return "Procesar de nuevo"}()
    lazy var caphome_Tit : String = {return "CASAS"}()
    lazy var capexp_Tit : String = {return "EXPERIENCIAS"}()
    lazy var caprest_Tit : String = {return "RESTAURANTE"}()
    lazy var remfilt_Tit : String = {return "Eliminar todos los filtros"}()
    lazy var remfilt_Msg : String = {return "No pudimos encontrar ningún listado. Intenta quitar tus filtros."}()
    lazy var map_Tit : String = {return "MAPA"}()
    lazy var filt_Tit : String = {return "FILTRAR"}()
    lazy var clrall_Tit : String = {return "Limpiar todo"}()
    
    //CategorySelection
    lazy var whattodo_Tit : String = {return "¿Qué hacer?"}()
    
    //AlertView
    lazy var offerr_Title: String = {return "Error: actualmente estás desconectado"}()
    lazy var off_Err: String = {return "actualmente estás desconectadoe"}()
    lazy var error_Tit: String = {return "Error:"}()
    
    //FilterVC
    lazy var amenit_Tit : String = {return "Comodidades"}()
    lazy var baths_Tit : String = { return "Baños"}()
    lazy var beddrms_Title : String = { return "dormitorios"}()
    lazy var rese_Titl : String = {return "Reiniciar"}()
    lazy var seeall_Ameniti : String = {return "Ver todas las comodidades"}()
    lazy var beds_Tit: String = {return "camas"}()
    lazy var filts_Tit : String = {return "Filtros"}()
    lazy var instbk_Only : String = {return "Solo libro instantáneo"}()
    lazy var instbk_Msg : String = {return "Reserve sin esperar a que el anfitrión responda"}()
    lazy var bedroom_Tit: String = {return "dormitorios"}()
    lazy var bath_Tit: String = {return "baños"}()
    
    //MapRoomCell
    lazy var nothing_Title : String = {return "Nada guardado todavía"}()
    lazy var listing_Title : String = {return "Listado"}()
    lazy var listings_Title: String = {return "Listados"}()
    
    //HostInboxVC
    lazy var nores_Req : String = {return "No hay solicitudes de reserva"}()
    lazy var nores_mess : String = {return "No tiene solicitudes de reserva ni consultas de reserva para responder en este momento."}()
    lazy var resers_Title: String = {return "Reservaciones"}()
    lazy var preacc_Title : String = {return "Pre-aceptar"}()
    
    //SpaceType
    lazy var listsp_Tit : String = {return "Lista tu espacio"}()
    lazy var listsp_Mes : String = {return "¿Qué tipo de espacio quieres enumerar?"}()
    
    //PropertyType
    lazy var proptyp_Tit : String = {return "tipo de propiedad"}()
    lazy var proptyp_Msg : String = {return "Niza ¿En qué tipo de lugar está toda tu casa?"}()
    lazy var mr_Tit : String = {return "Más"}()
    
    //FilterRoomTypes
    lazy var rom_Typs : String = {return "Tipos de habitaciones"}()
    
    //Location
    lazy var loc_Tit : String = {return "Ubicación"}()
    lazy var loc_Msg : String = {return "¿En qué ciudad se encuentra tu apartamento?"}()
    lazy var next_Tit : String = {return "Próximo"}()
    
    
    //SearchVC
    lazy var locpermisson_Tit : String = {return "Permiso de ubicación"}()
    lazy var grant_Tit: String = {return "Por favor conceda"}()
    lazy var locset_Title: String = {return "acceso a su ubicación a través de la configuración> privacidad> servicios de ubicación."}()
    lazy var setting_Title: String = {return "Configuraciones"}()
    lazy var popdest_Title: String = {return "Destinos populares"}()
    
    //DescriptionsDetailPageVC
    lazy var det_Desc : String = {return "Detail Descriptions"}()
    
    //RoomDetailPage
    lazy var checkavail_Title: String = {return "Consultar disponibilidad"}()
    lazy var availb_Tit : String = { return "Disponibilidad"}()
    lazy var abt_SerTit : String = { return "Acerca de este servicio"}()
    lazy var chk_Tit : String = { return "Comprobar"}()
    lazy var mssg_Titt : String = { return "Mensaje"}()
    lazy var cnthst_Tit : String = { return "Contactar al anfitrión"}()
    lazy var descs_Title : String = {return "Descripciones"}()
    lazy var perday_Title : String = {return "por dia"}()
    lazy var ament_Tit : String = {return "Amenidad"}()
    lazy var smap_Tit : String = {return "Mapa"}()
    lazy var features_Tit: String = {return "Feature"}()
    lazy var space_Tit: String = {return "Space"}()
    lazy var available_TimeTit: String = {return "AvailableTime"}()
    lazy var festievnt_Tit: String = {return "Festival"}()
    lazy var abt_Tit : String = {return "Acerca de"}()
    lazy var prop_Tit : String = {return "Propiedad"}()
    lazy var stexp_Title : String = {return "Empieza a explorar"}()
    lazy var pernight_Title: String = {return "por noche"}()
    lazy var simlist_Title : String = {return "Listado similar"}()
    lazy var cancelpolicy_Title: String = {return "Política de cancelación"}()
    lazy var houserules_Title: String = {return "Reglas de casa"}()
    lazy var additionalprice_Title: String = {return "Precios adicionales"}()
    lazy var checkavailab_Title: String = {return "Consultar disponibilidad"}()
    lazy var contachost_Title: String = {return "Contactar al anfitrión"}()
    lazy var triplength_Title: String = {return "Longitud del viaje"}()
    lazy var caproom_Title: String = {return "Habitaciones"}()
    lazy var capguest_Title: String = {return "Invitados"}()
    lazy var capbed_Title: String = {return "Camas"}()
    lazy var capbath_Title: String = {return "Baño"}()
    lazy var redmore_Title: String = {return "..Lee mas"}()
    lazy var hostby_Title: String = {return "Alojado por"}()
    
    
    /// Event Error Message
    lazy var choose_Activity: String = {return "Please Choose your Activity"}()
    lazy var choose_Dates: String = {return "Please Choose your Dates"}()
    lazy var add_GuestCount: String = {return "Please add your guest count"}()
     lazy var maximum_guestcount: String = {return "Maximum guest cound should be"}()
    
    /// TimeChoosing Page Hints
    lazy var startTime: String = {return "Start time"}()
    lazy var endTime: String = {return "End time"}()
    
    //Choose Time Error Message
    lazy var endTimeErrorMsg : String = {return "Please select start time"}()
    
    //Error Messages
    lazy var nodat_Found : String = {return "Datos no encontrados"}()
    
    //PriceBreakdown
    lazy var price_Msg : String = {return "Esto nos ayuda a ejecutar nuestra plataforma y ofrecer servicios como soporte 24/7 en su viaje."}()
    lazy var pay_Brk : String = {return "Desglose de pagos"}()
    
    //WWCalendarTimeSelector
    lazy var strtdat_Title: String = {return "Fecha de inicio"}()
    lazy var enddat_Title: String = {return "Fecha final"}()
    lazy var checkin_Title: String = {return "Registrarse"}()
    lazy var checkout_Title: String = {return "Revisa"}()
    lazy var save_Tit: String = {return "Salvar"}()
    lazy var thosdate_Err: String = {return "Esas fechas no están disponibles."}()
    
    //ReviewCell
    lazy var readall_Title: String = {return "Lee todo"}()
    
    //ShareVC
    lazy var twitlog_Err: String = {return "Inicie sesión en una cuenta de Twitter para compartir."}()
    lazy var checkout_Msg: String = {return "Echa un vistazo a este fantástico lugar para alojarse"}()
    lazy var hey_Title : String = {return "Oye,"}()
    lazy var grt_Place : String = {return "Encontré un excelente lugar para hospedarme"}()
    lazy var on_Tit : String = {return "sobre"}()
    lazy var whtthnk_Title : String = {return "¿Qué piensas?"}()
    
    //ContactHostVC
    lazy var hostedby_Title: String = {return "alojado por"}()
    lazy var yourmsg_Title: String = {return "Tu mensaje"}()
    lazy var aapreciate_Msg: String = {return "Los anfitriones aprecian un saludo atento"}()
    lazy var change_Title: String = {return "Cambio"}()
    lazy var msghst_Tit : String = {return "Host de mensaje"}()
    
    //AddMessageVC
    lazy var stps_Lftbk : String = {return "Pasos para reservar"}()
    lazy var seepric_Dwn : String = {return "Ver desglose de precios"}()
    
    //AddHostMessageVC
    lazy var int_Yrslf : String = {return "Presentarte"}()
    lazy var tel_Tit : String = {return "Contar"}()
    lazy var tel_Desc : String = {return "un poco sobre ti y tu viaje."}()
    
    lazy var dat_Title : String = {return "Fecha"}()
    lazy var guess_Tit : String = {return "Invitados"}()
    lazy var mnthly_Title : String = {return "mensual"}()
    lazy var wekly_Title : String = {return "semanal"}()
    lazy var nigt_Title : String = {return "noche"}()
    lazy var dayy_Title : String = {return "día"}()
    lazy var dayys_Title : String = {return "dias"}()
    
    //AdditionalPrice
    lazy var ext_Peop : String = {return "Personas extra"}()
    lazy var sec_Dep : String = {return "Depósito de seguridad"}()
    lazy var clean_Fee : String = {return "Tarifa de limpieza"}()
    lazy var addpric_Msg: String = {return "Puede dar descuentos para su lista desde nuestro sitio web"}()
    lazy var staydiscount_Title: String = {return "Duración de la estancia descuentos"}()
    lazy var earlydiscount_Title: String = {return "Descuentos por reserva anticipada"}()
    lazy var lastdisc_Title: String = {return "Descuentos de ultima hora"}()
    
    //RoomsHouseRules
    lazy var abthome_Title: String = {return "Sobre esta casa"}()
    lazy var agree_Titlle : String = {return "Aceptar"}()
    
    //AmenitiesVC
    lazy var wifi_Tit : String = {return "Wifi"}()
    lazy var aircond_Tit : String = {return "Aire acondicionado"}()
    lazy var pool_Tit : String = {return "Piscina"}()
    lazy var kit_Tit : String = {return "Cocina"}()
    lazy var park_Tit : String = {return "Estacionamiento"}()
    lazy var brkfst_Tit : String = {return "Desayuno"}()
    lazy var indoor_Tit : String = {return "Indoor fireplace"}()
    lazy var heat_Tit : String = {return "Calefacción"}()
    lazy var fam_Tit : String = {return "Para toda la familia"}()
    lazy var wash_Tit : String = {return "Lavadora"}()
    lazy var dry_Tit : String = {return "Secadora"}()
    lazy var esst_Tit : String = {return "Esenciales"}()
    lazy var shmp_Tit : String = {return "Champú"}()
    lazy var hairdry_Tit : String = {return "Secador de pelo"}()
    lazy var iron_Tit : String = {return "Planchar"}()
    
    //SearchVC
    lazy var where_To : String = {return "¿A donde?"}()
    lazy var nearby_Tit : String = {return "Cerca"}()
    lazy var crtlist_Tit : String = {return "Lista creada"}()
    lazy var anywhere_Tit : String = {return "En cualquier sitio"}()
    lazy var clr_Tit : String = {return "Claro"}()
    
    //ProfileSettings
    lazy var termser_Title : String = {return "Términos de servicio"}()
    
    //WhishListVC
    lazy var notlog_WishMsg : String = {return "Recoge lugares para quedarte y cosas que hacer tocando el ícono del corazón"}()
    lazy var nowish_Tit : String = {return "No hay listas de deseos"}()
    lazy var nowish_Msg : String = {return "No tienes listas de deseos en este momento."}()
    lazy var find_HomeTit : String = {return "Encuentra casas"}()
    
    //AddGuestEmailCell
    lazy var email_Opt : String = {return "Dirección de correo electrónico (opcional)"}()
    
    //AddWhishListVC
    lazy var pub_Title : String = {return "Público"}()
    lazy var pri_Title : String = {return "Privado"}()
    lazy var chs_Tit : String = {return "Elige una lista"}()
    lazy var visible_Msg: String = {return "Visible para todos e incluido en \nyour public"}()
    lazy var profi_Title: String = {return "perfil"}()
    lazy var visiblefrnd_Msg: String = {return "Visible solo para ti y cualquier amigo que invites"}()
    
    //CreateWhishList
    lazy var creat_List : String = {return "Crear una lista"}()
    lazy var creat_Tit : String = {return "Crear >"}()
    lazy var privacy_Tit : String = {return "Intimidad"}()
    
    //WhishListDetailsVC
    lazy var avail_exps : String = {return "experiencias disponibles"}()
    lazy var avail_hom : String = {return "hogar disponible"}()
    lazy var nothingsave_Desc : String = {return "Cuando vea algo que vincule, toque el corazón para guardarlo. Si está planeando un viaje con otros, invítelos para que puedan guardar y votar sus favoritos."}()
    lazy var avail_homs : String = {return "casas disponibles"}()
    lazy var wish_name : String = {return "Por favor ingrese el nombre de la lista de deseos"}()
    lazy var sav_Chgs : String = {return "Guardar cambios"}()
    lazy var tit_Titl : String = {return "Título"}()
    lazy var wis_Name : String = {return "Nombre de la lista de deseos ..."}()
    lazy var wis_Updt : String = {return "WishList actualizado con éxito"}()
    lazy var wislis_Every : String = {return "La lista no es visible para todos"}()
    lazy var wislis_Vis : String = {return "La lista no solo es visible para usted"}()
    lazy var mak_Pub : String = {return "Hacer público"}()
    lazy var mak_Priv : String = {return "Hazlo privado"}()
    lazy var del_List : String = {return "Eliminar esta lista"}()
    lazy var rem_List : String = {return "Eliminar listado"}()
    lazy var rem_Tit : String = {return "retirar"}()
    
    //ExpReceiptHeaderView
    lazy var hourexp_Title: String = {return "horas de experiencia"}()
    lazy var tott_Tit : String = {return "Total"}()
    lazy var bedd_Title : String = {return "Cama"}()
    lazy var beddrm_Title : String = {return "Habitación"}()
    
    //PriceBreakDown
    lazy var nights_Title: String = {return "noches"}()
    lazy var nightsin_Title: String = {return "noches en"}()
    lazy var totalpayout_Title: String = {return "Pago total"}()
    lazy var hostfee_Title: String = {return "Tarifa de anfitrión"}()
    lazy var servicefee_Title: String = {return "Tarifa de servicio"}()
    lazy var totlaprice_Title: String = {return "Precio total"}()
    
    //BookingVC
    lazy var Book_Now : String = {return "Reservar ahora"}()
    lazy var hostmsg_Title : String = {return "Mensaje de host"}()
    lazy var lblTotText1 : String = { return "Total"}()
    lazy var edit_Title: String = { return "Editar"}()
    
    //MakePaymentVC
    lazy var select_Pay : String = {return "selecciona tu forma de pago"}()
    lazy var add_Pay : String = {return "Agregar pago"}()
    lazy var paypal_Tit : String = {return "PayPal"}()
    lazy var crdit_Titlt : String = {return "Tarjeta de crédito"}()
    
    //DiscountPageVC
    lazy var nostay_Disc : String = {return "No se encontraron descuentos de duración de estadía"}()
    lazy var nobir_Disc : String = {return "No se encontraron descuentos por reserva anticipada"}()
    lazy var nolst_Disc : String = {return "No se encontraron descuentos de último minuto"}()
    lazy var night_Tit : String = {return "Noches"}()
    lazy var percen_Tit : String = {return "Porcentaje"}()
    lazy var setpric_Msg : String = {return "Puede establecer un precio para reflejar el espacio, las comodidades y la hospitalidad que brindará"}()
    
    //FilterRoomTypes
    lazy var shareroom_Msg: String = {return "\nNota: esta es una habitación compartida"}()
    
    //HostMessageVC
    lazy var editmsg_Title : String = {return "Editar mensaje"}()
    lazy var addmsg_Title : String = {return "Agregar mensaje"}()
    
    //HouseRulesVC
    lazy var houserule_Msg1: String = {return "Cuando te quedas en un"}()
    lazy var houserule_Msg2: String = {return "te quedas en la casa de alguien. Tendrá que aceptar las reglas de la casa de Simon & Wendy's antes de poder reservar."}()
    
    //inboxVC
    lazy var msghost_Msg: String = {return "Los mensajes de tu anfitrión aparecerán aquí"}()
    lazy var resub_Tit : String = { return "volver a presentar"}()
    lazy var nomsg_Msg: String = {return "No tienes mensajes"}()
    lazy var youhav_No : String = {return "No tienes"}()
    lazy var youhave_Title: String = {return "Tienes"}()
    lazy var unreadmsg_Title: String = {return "mensajes no leídos"}()
    lazy var nounread_Msg: String = {return "No tienes mensajes no leídos"}()
    
    //Inbox DetailVC
    lazy var payment_Title: String = {return "Pago"}()
    lazy var discount_Title: String = {return "descuento"}()
    lazy var lengthdis_Title: String = {return "descuento de duración"}()
    lazy var customer_Title: String = {return "Recibo del cliente"}()
    lazy var Cancelreq_Title : String = {return "Cancelar petición"}()
    lazy var MsgHis_Title : String = {return "Historial de mensajes"}()
    
    //ConversationVC
    lazy var preapprove_Title: String = {return "Pre-Aprobar"}()
    lazy var cancelreser_Title: String = {return "Cancelar la reserva"}()
    lazy var archive_Title: String = {return "Archivo"}()
    lazy var help_Title: String = {return "Ayuda"}()
    lazy var write_Msg : String = {return "Escribe un mensaje"}()
    
    //HostinboxVC
    lazy var noreser_Msg: String = {return "No tienes reserva"}()
    lazy var expires_Title: String = {return "Expira"}()
    lazy var discuss_Title: String = {return "Discutir"}()
    lazy var msghist_Title: String = {return "Historial de mensajes"}()
    lazy var totalcost_Title: String = {return "Coste total"}()
    lazy var decline_Title: String = {return "Disminución"}()
    lazy var addguestfee_Title: String = {return "Tarifa de invitado adicional"}()
    lazy var secfee_Title: String = {return "Tasa de seguridad"}()
    lazy var cleanfee_Title: String = {return "Tarifa de limpieza"}()
    lazy var reser_Tit : String = {return "reserva"}()
    lazy var resers_Tit : String = {return "reservas"}()
    
    //PreAcceptVC
    lazy var thisreq_Title : String = {return "Esta petición"}()
    
    //TripHistoryVC
    lazy var send_Title : String = {return "Enviar"}()
    
    //ViewReceipt
    lazy var hostapp_Msg : String = {return "Anfitrión aprecia un hola pensativo"}()
    
    //StripeVC
    lazy var acc_NumTit: String = {return "Número de cuenta"}()
    lazy var brnch_Nam : String = {return "Nombre de la sucursal"}()
    lazy var bank_Cd : String = {return "Codigo bancario"}()
    lazy var acc_OwnName : String = {return "Nombre del titular de la cuenta"}()
    lazy var male_Title: String = {return "Masculino"}()
    lazy var bankst_Tit : String = {return "Sucursal del Estado del Banco"}()
    lazy var clrcod_Tit : String = {return "Código de compensación"}()
    lazy var brnch_Tit : String = {return "Código de sucursal"}()
    lazy var phn_Num : String = {return "Número de teléfono"}()
    lazy var trnas_Num : String = {return "Número de Tránsito"}()
    lazy var acc_OwnNa : String = {return "Nombre del titular de la cuenta"}()
    lazy var intnum_Tit : String = {return "Numero de Institucion"}()
    lazy var rount_Num : String = {return "Número de ruta"}()
    lazy var ssn4_Tit : String = {return "SSN últimos 4 dígitos"}()
    lazy var bnk_namme : String = {return "Nombre del banco"}()
    lazy var bnk_Code : String = {return "Codigo bancario"}()
    var srtcd_Tit : String  = {return "Código de clasificacion"}()
    lazy var female_Title: String = {return "Hembra"}()
    lazy var takephoto_Title: String = {return "Tomar foto"}()
    lazy var choosephoto_Title: String = {return "Escoge una foto"}()
    lazy var error_Title: String = {return "Error"}()
    lazy var legal_Doc : String = {return "Documento legal"}()
    lazy var additional_Doc : String = { return "documento adicional"}()
    lazy var nocam_Error: String = {return "Device has no camera"}()
    lazy var updatlegal_Error: String = {return "Please update a legal document."}()
    lazy var updatAddition_Error: String = {return "Please update a additional document."}()
    lazy var acc_HoldName : String = {return "nombre del titular de la cuenta"}()
    lazy var add1_Val : String = {return "Dirección 1"}()
    lazy var legalDocError : String = { return "Por favor Cargar documento"}()
    lazy var strip_Det : String = {return "Detalles Stripe"}()
    lazy var stat_Prov : String = {return "Provincia del estado"}()
    lazy var iban_Num : String = {return "Número IBAN"}()
    
    //ProfileVC
    lazy var travel_Title: String = {return "viajar"}()
    lazy var swit_Tit : String = {return "cambiar"}()
    lazy var viewedt_Tit : String = { return "Ver y editar el perfil"}()
    lazy var switchhost_Title: String = {return "Cambiar a host"}()
    lazy var switchtravel_Title: String = {return "Cambiar a viajar"}()
    lazy var helpandsup_Title: String = {return "Servicio de asistencia"}()
    lazy var whyhost_Title: String = {return "Por qué hospedar"}()
    lazy var editprof_Title: String = {return "Editar perfil"}()
    
    //ViewProfileVC
    lazy var memsin_Tit : String = {return "Miembro desde"}()
    lazy var verif_Info : String = {return "Verificar información"}()
    
    //EditLengthOfDiscountsVC
    lazy var selnigh_Tit : String = {return "Noches selectas"}()
    
    //ProfileSettings
    lazy var profset_Payout : String = {return "Métodos de pago"}()
    lazy var vers_Tit : String = {return "Versión"}()
    lazy var logot_Tit : String = {return "Cerrar sesión"}()
    
    //EditProfileVC
    lazy var upload_Error : String = {return "Subida fallida. Inténtalo de nuevo"}()
    lazy var notspeci_Title : String = {return "No especificado"}()
    lazy var firstname_Tit : String = {return "Nombre de pila"}()
    lazy var lastname_Tit : String = {return "Apellido"}()
    lazy var abtme_Tit : String = {return "Sobre mi"}()
    lazy var gender_Tit : String = {return "Género"}()
    lazy var bithdt_Tit : String  = {return "Fecha de nacimiento"}()
    lazy var loca_Tit : String = {return "Ubicación"}()
    lazy var schl_Tit : String = {return "Colegio"}()
    lazy var wrk_Tit : String = {return "Trabajo"}()
    
    lazy var frst_Nam : String = {return "Ingrese nombre"}()
    lazy var lst_Nam : String = {return "Introduzca el apellido"}()
    lazy var abt_Me : String = {return "Sobre mi"}()
    lazy var sel_Gen : String = {return "Seleccione género"}()
    lazy var sel_DOb : String = {return "Seleccione fecha de nacimiento"}()
    lazy var ent_Email : String = {return "Ingrese correo electrónico"}()
    lazy var ent_Loc : String = {return "Ingrese ubicación"}()
    lazy var ent_Sch : String = {return "Entrar a la escuela"}()
    lazy var ent_wrk : String = {return "Entrar al trabajo"}()
    lazy var edt_Titl : String = {return "Editar título"}()
    
    //AboutPayout
    lazy var payout_Tit : String = {return "Pagos"}()
    lazy var setup_Title : String = {return "Configura tu"}()
    lazy var paypal_Meth : String = {return "Añadir Paypal Pagar"}()
    lazy var submit_Tit : String = {return "Enviar"}()
    lazy var stripe_Meth : String = {return "Agregar pago Stripe"}()
    lazy var payoutmeth_Title : String = {return "método de pago"}()
    lazy var updatedob_Error: String =  {return "Actualice el DOB en EditProfile"}()
    lazy var payot_Msg : String = {return "Su pago es lo que gana al hospedar a un invitado. Los pagos se envían 24 horas después de cada check-in."}()
    
    //PayoutDetails
    lazy var address_Title : String = {return "Dirección"}()
    lazy var addresspay_Title : String = { return "Dirección de PAYPAL"}()
    lazy var address2_Title : String = {return "Dirección 2"}()
    lazy var city_Title : String = {return "Ciudad"}()
    lazy var state_Title : String = {return "Estado"}()
    lazy var postal_Title : String = {return "Código postal"}()
    lazy var country_Title : String = {return "País"}()
    lazy var paypal_EmailId : String = {return "ID de correo electrónico de PayPal"}()
    lazy var def_Tit : String = {return "Defecto"}()
    lazy var mk_Deftit : String = {return "Hacer por defecto"}()
    lazy var dele_Tit : String = {return "Borrar"}()
    lazy var paypal_EmailErr : String = {return "Por favor ingrese la identificación de correo electrónico de Paypal"}()
    lazy var addr_FieldErr : String = {return "Por favor complete el campo Dirección"}()
    lazy var city_FieldErr : String = {return "Por favor llene el campo de la ciudad"}()
    lazy var state_FieldErr : String = {return "Por favor complete el campo Estado"}()
    lazy var postalcode_FieldErr : String = {return "Por favor complete el campo del Código Postal"}()
    lazy var country_FieldErr : String = {return "Por favor complete el campo País"}()
    
    //TripLengthVC
    lazy var guestmin_Title : String = {return "Estancia de invitado por mínimo"}()
    lazy var during_Title : String = {return "Durante"}()
    lazy var night_Title : String = {return "Noches"}()
    lazy var guestmax_Title : String = {return "Guest Stay para el máximo"}()
    
    //EditEarliyDiscountsVc
    lazy var earlybird_Disc : String = {return "Descuentos por reserva anticipada"}()
    lazy var lastmin_Disc : String = {return "Descuentos de último minuto"}()
    lazy var discpercent_Err : String = {return "Por favor ingrese el porcentaje de descuento"}()
    lazy var numofnight_Err : String = {return "Por favor ingrese el número de noches"}()
    
    //EditLengthOfDiscountsVC
    lazy var choosenight_Error : String = {return "Por favor elige una noche"}()
    
    //CustomMinMaxVC
    lazy var edt_Tit : String = {return "editar"}()
    lazy var pls_Ent : String = {return "Por favor, introduzca el"}() //Por favor, introduzca el
    lazy var choose_DtError : String = {return "Por favor, elija una fecha"}()
    lazy var choosestdate_Error : String = {return "Por favor, elija la fecha de inicio"}()
    lazy var chooseeddate_Error : String = {return "Por favor, elija la fecha de finalización"}()
    lazy var minsty_Error : String = {return "Por favor ingrese el campo de estadía mínima"}()
    lazy var maxsty_Error : String = {return "Ingrese el campo de estadía máxima"}()
    
    //SSCalendarTimeSelector Days,done,cancel
    lazy var datealready_Reser : String = {return "Esta fecha ya está reservada"}()
    lazy var saving_Title : String = {return "Ahorro..."}()
    lazy var svd_Title : String = {return "Salvado..."}()
    lazy var addlist_Title : String = {return "Agregar listado"}()
    lazy var sve_Chngs : String = {return "Guardar cambios"}()
    lazy var avail_Tit : String = {return "Disponible"}()
    lazy var blck_Tit : String = {return "Obstruido"}()
    lazy var night_Pric : String = {return "Precio nocturno"}()
    lazy var noliss_Tit : String = {return "No listado"}()
    lazy var noliss_Msg : String = {return "No tienes listado en este momento."}()
    lazy var mon_Sym : String = {return "L"}()
    lazy var tues_Sym : String  = {return "M"}()
    lazy var wednes_Sym : String = {return "X"}()
    lazy var thrus_Sym : String = {return "J"}()
    lazy var fri_Sym : String = {return "V"}()
    lazy var sat_Sym : String = {return "S"}()
    lazy var sun_Sym : String = {return "D "}()
    
    //Reservation
    lazy var view_Det : String = {return "Ver detalles"}()
    
    //CreatedList
    lazy var steps_Title : String = {return "pasos"}()
    
    //HostHome
    lazy var noreser_Req : String = {return "No hay solicitudes de reserva"}()
    lazy var yes_Tit : String = {return "Sí"}()
    lazy var no_Tit : String = {return "No"}()
    
    //HostListing
    lazy var unlis_Title : String = {return "No estante en la lista"}()
    lazy var host_List : String = {return "Sus listados"}()
    lazy var in_Title : String = {return "en"}()
    lazy var lis_Title : String = {return "Listado"}()
    lazy var stplis_Title : String = {return "pasos para enumerar"}()
    
    //SelectionCountryVC
    lazy var sel_Coun : String = {return "Seleccionar país"}()
    
    //LocationVC
    lazy var exactloc_Title : String = {return "Ubicación exacta encontrada"}()
    lazy var exactlocnot_Title : String = {return "Ubicación exacta no encontrada"}()
    lazy var locfound_Title : String = {return "Lugar encontrado"}()
    lazy var manualpin_Title : String = {return "¿Desea anclar manualmente la ubicación de este listado en un mapa?"}()
    lazy var edtAdd_Title : String = {return "Editar dirección"}()
    lazy var pinMap_Title : String = {return "Pin en el mapa"}()
    
    //RoomBedSelection
    lazy var homtyp_Title : String = {return "Tipo de casa"}()
    lazy var some_Titt : String = { return "Algunos"}()
    lazy var bedtyp_Title : String = {return "Tipo de cama"}()
    lazy var rom_Typ : String = {return "Tipo de habitación"}()
    lazy var bdrms_Tit : String = {return "Dormitorios"}()
    lazy var maxgues_Tit : String = {return "Max invitados"}()
    lazy var coupamnt_Tit : String = { return "La cantidad de cupones"}()
    lazy var guessts_Tit : String = { return "huéspedes"}()
    lazy var guesss_Tit : String = { return "huésped"}()
    
    //AddRoomDetails
    lazy var desplac_Title : String = {return "Describe tu lugar"}()
    lazy var nolis_Err : String = { return "Sala de espera listado de aprobación para admin"}()
    lazy var prev_Tit : String = {return "Avance"}()
    lazy var addBedTypeError : String = { return "Por favor Añadir Al menos Tipo Uno con cama"}()
    lazy var addpht_Tit : String = {return "Agregar fotos"}()
    lazy var addphts_Tit : String = {return "Añadir foto"}()
    lazy var optidet_Title : String = {return "Detalles opcionales"}()
    lazy var set_Price : String = {return "Fijar precio"}()
    lazy var set_Addr : String = {return "Establecer dirección"}()
    lazy var sethous_Rules : String = {return "Establecer reglas de la casa"}()
    lazy var setbook_Type : String = {return "Establecer tipo de libro"}()
    lazy var summ_Highlight : String = {return "Resuma los aspectos más destacados de su listado"}()
    lazy var sug_Price : String = {return "Pruebe nuestro precio sugerido para comenzar"}()
    lazy var conf_Price : String = {return "Solo los invitados confirmados ven su dirección"}()
    lazy var guest_Agree : String = {return "Los huéspedes aceptan las reglas antes de reservar"}()
    lazy var guest_Book : String = {return "Cómo pueden reservar los huéspedes"}()
    lazy var ready_List : String = {return "Listo para listar"}()
    lazy var list_Space : String = {return "Lista tu espacio"}()
    lazy var unlist_Space : String = {return "Anula tu espacio"}()
    lazy var expect_Behave : String = {return "¿Cómo espera que se comporten los invitados?"}()
    lazy var booktyp_Tit : String = {return "Tipo de reserva"}()
    lazy var rom_Sucess : String = { return "Detalles de las habitaciones añadido correctamente."}()
    
    //AddRoomImageVC
    lazy var internal_Err : String = {return "Se produjo un error inter, intente de nuevo ..."}()
    lazy var imglarge_Error : String = {return "¡¡¡Subida fallida!!!. La imagen es muy grande."}()
    
    //SmartPricing
    lazy var minprice_Trip : String = {return "Consejo de precio mínimo: ₹1,084"}()
    lazy var maxprice_Trip : String  = {return "Consejo de precio máximo: ₹4,644"}()
    lazy var whyimp_Setting : String  = {return "¿Por qué es importante esta configuración?"}()
    
    //DescripePlace
    lazy var add_Tit : String  = {return "Añade un titulo"}()
    lazy var clr_Desc : String  = {return "Sea claro y descriptivo."}()
    lazy var writ_Summ : String  = {return "Escribe un resumen"}()
    lazy var travabt_Space : String  = {return "Dile a los viajeros lo que te gusta del espacio. Puede incluir detalles sobre la decoración, las comodidades que incluye y el vecindario."}()
    lazy var edit_Tit : String  = {return "Editar título"}()
    lazy var edit_Summ : String  = {return "Editar resumen"}()
    
    //ExperienceDetailsController
    lazy var send_MsgTit : String = {return "Enviar mensaje"}()
    
    //AboutListing
    lazy var thespac_Tit : String  = {return "El espacio"}()
    lazy var guesacc_Tit : String  = {return "Acceso de invitado"}()
    lazy var interact_Guest : String  = {return "Interacción con invitados"}()
    lazy var overview_Tit : String  = {return "Visión general"}()
    lazy var getarnd_Tit : String  = {return "Moverse"}()
    lazy var otherthng_Tit : String  = {return "Otras cosas a tener en cuenta"}()
    lazy var houserul_Titl : String  = {return "Reglas de casa"}()
    lazy var addinf_Space : String  = {return "Puede agregar más información sobre lo que hace que su espacio sea único."}()
    lazy var trav_Access : String = {return "Informe a los viajeros a qué partes del espacio podrán acceder."}()
    lazy var availgues_Stay : String  = {return "Informe a los invitados si estará disponible para ofrecer ayuda durante su estadía."}()
    lazy var shwpeop_Uniq : String  = {return "Muestre a las personas que miran su página de listado lo que hace que su vecindario sea único."}()
    lazy var pub_Trans : String   = {return "Puede informar a los viajeros si su anuncio está cerca del transporte público (o lejos de él). También puede mencionar las opciones de estacionamiento cercanas."}()
    lazy var trav_Othr : String   = {return "Let travelers know if there are other details that will impact their stay."}()
    lazy var beh_Expt : String   = {return "¿Cómo espera que se comporten sus invitados?"}()
    
    lazy var travoth_Dets : String   = {return "Informe a los viajeros si hay otros detalles que afectarán su estadía."}()
    lazy var det_Title : String   = {return "Detalles"}()
    lazy var tneigh_Title : String   = {return "El vecindario"}()
    lazy var exdet_Title : String   = {return "Detalles extra"}()
    
    //Describe your place
    lazy var descpl_Title : String = {return "Describe tu lugar"}()
    lazy var addtit_Title : String = {return "Añade un titulo"}()
    lazy var writsum_Title : String = {return "escribe un resumen"}()
    
    //EditTitleVC
    lazy var chlef_Tit : String   = {return "Caracteres restantes"}()
    lazy var edittit_Tit : String = {return "Editar título"}()
    lazy var tspc_Title : String   = {return "El espacio"}()
    lazy var gustAcc_Title : String   = {return "Acceso de invitado"}()
    lazy var interac_Guest : String   = {return "Interacción con invitados"}()
    lazy var overv_Title : String  = {return "Visión general"}()
    lazy var getarnd_Title : String   = {return "Moverse"}()
    lazy var othtin_Title : String   = {return "Otras cosas a tener en cuenta"}()
    lazy var housrul_Title : String   = {return "Reglas de casa"}()
    
    //EditPriceVC
    lazy var romadpri_Tit : String   = {return "Habitación y precios adicionales cambiados a precio mínimo"}()
    lazy var edtpric_Tit : String = {return "Editar precio"}()
    lazy var fixpric_Msg : String = {return "El precio fijo es su tarifa nocturna predeterminada"}()
    lazy var chng_Curr : String = {return "Cambiar moneda"}()
    lazy var learn_Mre : String = {return "Aprende más"}()
    
    //AllAmentiesVC
    lazy var estent_Title : String   = {return "Esenciales~~~1"}()
    lazy var tv_Title : String   = {return "televisión~~~2"}()
    lazy var cabltv_Title : String   = {return "Televisión por cable~~~3"}()
    lazy var aircon_Title : String   = {return "Aire acondicionado~~~4"}()
    lazy var heating_Title : String   = {return "Calefacción~~~5"}()
    lazy var kitchen_Title : String   = {return "Cocina~~~6"}()
    lazy var internet_Title : String   = {return "Internet~~~7"}()
    lazy var wifi_Title : String   = {return "Conexión inalámbrica a internet~~~8"}()
    lazy var hottub_Title : String   = {return "Bañera de hidromasaje~~~9"}()
    lazy var washer_Title : String   = {return "Lavadora~~~10"}()
    lazy var pool_Title : String   = {return "Piscina~~~11"}()
    lazy var dryer_Title : String   = {return "Secadora~~~12"}()
    lazy var brkfst_Title : String   = {return "Desayuno~~~13"}()
    lazy var freprk_Title : String   = {return "Aparcamiento gratuito en las instalaciones~~~14"}()
    lazy var gym_Title : String   = {return "Gimnasio~~~15"}()
    lazy var elev_Title : String   = {return "Ascensor en el edificio~~~16"}()
    lazy var indoor_Title : String   = {return "Chimenea interior~~~17"}()
    lazy var buzz_Title : String   = {return "Timbre / Intercomunicador inalámbrico~~~18"}()
    lazy var doorman_Title : String   = {return "Portero~~~19"}()
    lazy var shamp_Title : String   = {return "Champú~~~20"}()
    lazy var famkid_Title : String   = {return "Apto para familias / niños~~~21"}()
    lazy var smoking_Title : String   = {return "Fumar está permitido~~~22"}()
    lazy var suitevnt_Title : String   = {return "Apto para eventos~~~23"}()
    lazy var petallow_Title : String   = {return "Mascotas permitidas~~~24"}()
    lazy var petliv_Title : String   = {return "Las mascotas viven en esta propiedad~~~25"}()
    lazy var whelchr_Title : String   = {return "silla de ruedas accesible~~~26"}()
    lazy var smkdet_Title : String   = {return "Detector de humo~~~27"}()
    lazy var crbndet_Title : String   = {return "Detector de monóxido de carbono~~~28"}()
    lazy var firstaid_Title : String   = {return "Botiquín de primeros auxilios~~~29"}()
    lazy var sftcrd_Title : String   = {return "Tarjeta de seguridad~~~30"}()
    lazy var firext_Title : String   = {return "Extintor de incendios~~~31"}()
    
    //MaxMinStay1
    lazy var minmx_Stay : String = {return "Estancia mínima y máxima"}()
    lazy var min_Stay : String = {return "Estancia mínima"}()
    lazy var max_Stay : String = {return "Estancia máxima"}()
    lazy var req_Msg : String = {return "Agregar requisitos para temporadas o fines de semana"}()
    
    //CustomMinMax
    lazy var  reser_Sett : String = {return "Configuraciones de reserva"}()
    lazy var sel_Dat : String = {return "Seleccionar fechas"}()
    lazy var cus_Tit : String = {return "Personalizado"}()
    lazy var close_Tit : String = {return "Cerca"}()
    lazy var ent_Sdt : String = {return "Ingrese la fecha de inicio"}()
    lazy var ent_Edt : String = {return "Ingrese fecha de finalización"}()
    
    //Rooms&Beds
    lazy var roomandbeds:String = {return "Habitaciones & Camas"}()
    lazy var room_Desc : String = {return "Solo un poco más sobre tu casa ..."}()
    lazy var created_List : String = {return "Has creado tu listado"}()
    lazy var morestps_Msg : String = {return "más pasos para listar tu espacio"}()
    lazy var finish_List : String = {return "Terminar mi listado"}()
    lazy var noBedsErr : String = { return "no tiene camas en ella."}()
    //WhatIProvide
    lazy var fre_Tit : String = {return "Gratis"}()
    
    //DiscountPrice
    lazy var clenfee_Title : String   = {return "Tarifa de limpieza"}()
    lazy var addgues_Title : String   = {return "Invitados Adicionales"}()
    lazy var echgues_Title : String   = {return "Para cada invitado después"}()
    lazy var secdep_Title : String   = {return "Depósito de seguridad"}()
    lazy var weekendpric_Title : String   = {return "Precios de fin de semana"}()
    lazy var mnthly : String = {return "mensual"}()
    lazy var wkly : String = {return "semanal"}()
    lazy var addpri : String = {return "Precios adicionales"}()
    lazy var givdis_Msg : String = {return "Puede dar descuentos para su lista desde nuestro sitio web"}()
    
    //OptionalDetailVC
    lazy var reserset_Title : String  = {return "Configuraciones de reserva"}()
    lazy var curren_Title : String   = {return "Moneda"}()
    lazy var rombed_Title : String   = {return "Habitaciones y camas"}()
    lazy var descript_Title : String   = {return "Descripción"}()
    lazy var ament_Title : String   = {return "Comodidades"}()
    lazy var policy_Title : String   = {return "Política"}()
    lazy var pric_Title : String   = {return "Precio"}()
    lazy var flexi_Title : String   = {return "Flexible"}()
    lazy var mod_Title : String   = {return "Moderar"}()
    lazy var strt_Title : String   = {return "Estricto"}()
    
    //HostRulesVC
    lazy var suit_Child : String   = {return "Adecuado para niños \n (Edad 2-12)"}()
    lazy var suit_Infant : String   = {return "Adecuado para bebés \n (menores de 2 años)"}()
    lazy var pet_Allow : String   = {return "Mascotas permitidas"}()
    lazy var smok_Allow : String   = {return "Fumar está permitido"}()
    lazy var parties_Allow : String   = {return "Fiestas permitidas"}()
    lazy var Add_Rules : String   = {return "Reglas Adicionales"}()
    lazy var list_Suit : String   = {return "¿Mi anuncio es adecuado para niños?"}()
    
    //CalenderSettings
    lazy var adnot_Title : String   = {return "Preaviso"}()
    lazy var preptim_Title : String   = {return "Tiempo de preparación"}()
    lazy var disreq_Title : String   = {return "Solicitudes distantes"}()
    lazy var arok_Title : String   = {return "Estan bien"}()
    
    lazy var minmax_Title : String = {return "Estancia mínima y máxima"}()
    
    lazy var nig1min_Title : String = {return "1 noche minimo"}()
    
    lazy var samdy_Title : String = {return "Mismo día (hora de corte personalizable)"}()
    
    lazy var notic1dy_Msg : String = {return "Al menos 1 día de antelación"}()
    
    lazy var notic2dy_Msg : String = {return "Al menos 2 días de antelación"}()
    
    lazy var notic3dy_Msg : String = {return "Al menos 3 días de antelación"}()
    
    lazy var notic7dy_Msg : String = {return "Aviso de al menos 7 días"}()
    
    lazy var howtim_Msg : String = {return "Establezca cuánto tiempo necesita antes de que un huésped se registre."}()
    
    lazy var non_Title : String = {return "Ninguno"}()
    
    lazy var blk1nig_Msg : String = {return "Bloque 1 noche antes y después de las reservas."}()
    
    lazy var blktim_Msg : String = {return "Le permite bloquear el tiempo entre reservas para limpiar su espacio o relajarse."}()
    
    lazy var guearr_Msg : String = {return "Los huéspedes que lleguen en cualquier momento están bien"}()
    
    lazy var wnt3mnths_Msg : String = {return "Quiero invitados que lleguen dentro de 3 meses."}()
    
    lazy var wnt6mths_Msg : String = {return "Quiero invitados que lleguen dentro de los 6 meses."}()
    
    lazy var wnt1yr_Msg : String = {return "Quiero invitados que lleguen dentro de 1 año"}()
    
    lazy var blocreq_Msg : String = {return "Puede bloquear las solicitudes de reservas que están demasiado lejos para planificar."}()
    
    
    //AdvanceNotice
    //lazy var samedy_Title : String = {return "Mismo día (hora de corte personalizable)"}()
    
    //Update Location
    lazy var street_Tit : String = { return "Calle"}()
    lazy var aptbuild_Tit : String = { return "Piso / Edificio"}()
    lazy var zip_Titt : String = { return "cremallera"}()
    
    
    lazy var priv_Policy : String = { return "Política de privacidad"}()
    lazy var guesrefun_Policy : String = { return "Política de reembolso de invitados"}()
    lazy var hosguar_Terms : String = { return "Anfitrión Condiciones de garantía"}()
    
    lazy var remem_Tit : String = { return "Recuerda"}()
    
    lazy var addnw_List : String =  { return "Añadir nuevo listado"}()
    lazy var commonSpace : String = { return "Espacio común"}()
    lazy var sleep_Tit : String =  { return "Arreglos para dormir"}()
    lazy var bed_Tit: String =  { return "Habitación"}()
    
    //Mark:- HomeViewController
    lazy var cant_RoomTit : String = { return "No hemos encontrado ninguna habitación."}()
    lazy var cant_ExpTit : String = { return "No hemos podido encontrar experiencias."}()
    lazy var remfilt_Msg1 : String = { return "Prueba a eliminar los filtros"}()
    lazy var hi_Tit : String = { return "Hola"}()
        lazy var addBeds : String = { return "Añadir Camas"}()
    lazy var alert : String = { return "Alerta"}()
    lazy var discardMessage : String = { return "Todos los cambios realizados se discared!"}()
    lazy var discard : String = { return "Descarte"}()
    //Mark:- OwnerTitleVC
    lazy var ownby_Title : String = { return "Propiedad de"}()
    
    //Mark:- CouponVC
    lazy var ent_Coup : String = { return "Introduzca su código de descuento"}()
    lazy var app_Tit : String = { return "Aplicar"}()
    lazy var coup_Tit : String = { return "Código promocional"}()
    
    lazy var addgues_Tit : String = { return "Añadir un invitado"}()
    lazy var edtgues_Tit : String = { return "Editar un invitado"}()
    
    lazy var chkin_Tit : String = { return "Registrarse"}()
    lazy var chkout_Tit : String = { return "Revisa"}()
    
    lazy var percen_Sym : String = { return "%"}()
    lazy var cont_Admin : String = { return "Cuenta inhabilitada por favor póngase en contacto con administrador"}()
    
    //Mark:- AddSpaceViewController
    lazy var hostspc_Title : String = { return ", Informe acerca de su espacio"}()
    lazy var hostspc_Desc : String = { return "Cuanto más compartas, más rápido se puede conseguir una reserva"}()
    lazy var hostspc_Done : String = { return "Su perfil es"}()
    
    lazy var basic_Title : String = { return "Los basicos"}()
    lazy var set_Title : String = { return "Preparar"}()
    lazy var readytohost_Title : String = { return "Prepárese para alojar"}()
    lazy var spacegues_Title : String = { return "Detalles de las instalaciones, los huéspedes"}()
    lazy var photospac_Title : String = { return "Fotos, descripción espacial"}()
    lazy var pricavail_Title : String = { return "Fijación de precios, disponidad, la configuración de reserva"}()
    
     //Mark:- TypeSpaceViewController
    lazy var select_Title : String = { return "Seleccionar"}()
    lazy var typeSpaceTitle : String = { return "¿Qué tipo de espacio tiene usted?"}()
    lazy var asteriskSymbol: String = {return "*"}()

    //Mark:- AccessibityViewController
    lazy var spaceAccessTitle : String = {return "¿Cómo pueden los clientes acceder a su espacio"}()
    
    lazy var spcListDesc : String = {return "Sus listados aparecerán aquí"}()
    
    lazy var youarTitle : String = {return "estás"}()
    lazy var ofthrTitle : String = {return "parte del camino"}()
    lazy var fnshTitle : String = {return "Terminar su establecimiento"}()
    lazy var mrStpTit : String = {return "Más paso para completar"}()
    lazy var mrStpsTit : String = {return "Más pasos para completar"}()
    lazy var addAnthrSpc : String = {return "Añadir otro espacio"}()
    
    lazy var noOfRooms : String = {return "Número de habitaciones"}()
    lazy var noOfResRooms : String = {return "Cantidad de baños"}()
    lazy var flrNum : String = {return "número de la planta (si es aplicable)"}()
    lazy var estFootSpc : String = {return "Estimado en pies cuadrados del espacio disponible"}()
    
    lazy var peopSearch : String = { return "Personas que buscan en"}()
     lazy var peopSearchNew : String = { return "People all over the country are searching for a space like yours! When they use Spaciko to find you, they'll have the option to filter search results by listing basic information to find a match. By carefully completing the questions in this section, you can help them achieve their golas and, in turn, maximize your chances of begin found!"}()
    lazy var mthNeeds : String = { return "puede filtrar haciendo una lista de conceptos básicos para encontrar un espacio que se ajuste a sus necesidades."}()
    lazy var hlpEveOrg : String = { return "Ayuda Organizador del evento a encontrar el ajuste correcto"}()
    lazy var getStartList : String = {return "Lets get started listing your space"}()
    lazy var amentiesDesc : String = { return "Qué servicios ofrece su espacio?"}()
    lazy var maxGuestDesc : String = { return "Número máximo de huéspedes"}()
    
    lazy var servDesc : String = { return "¿Qué servicios y extras es lo que ofrece"}()
    lazy var addInfDesc : String = { return "Información adicional sobre los servicios, paquetes y tarifas:"}()
    
    lazy var chkGuidance : String = { return "Check-In Orientación"}()
    lazy var aptTitle : String = { return "# Apt, Piso #, etc."}()
    lazy var checkinDesc : String = { return "Introduzca Check-In Descripción Orientación"}()
    lazy var additionalInf : String = {return "Introducir información adicional"}()
    lazy var fulladdDesc : String = { return "¿Cuál es la dirección completa de su espacio?"}()
    lazy var shrDesc : String = { return "Compartir las instrucciones especiales necesarias para los organizadores para acceder al espacio. p.ej. código de bloqueo de la puerta, en el lugar gerente."}()
    lazy var infrmDesc : String = { return "Esta información sólo se compartirá con la confirmación de la reserva."}()
    lazy var chsOnMap : String = { return "Elija en el mapa"}()
    
    lazy var spcAlert : String = { return "Seleccione el tipo de espacio"}()
    lazy var footSpcAlert : String = { return "Por favor introduzca o Añadir metraje espacio de valores"}()
    lazy var spaceAccessAlert : String = { return "Por favor, seleccione Al menos uno de Acceso de la lista"}()
    lazy var guesCountAlert : String = { return "Por favor introduzca o Añadir recuento de resultados"}()
    lazy var spcAddressAlert : String = {return "Por favor, introduzca Espacio de direcciones"}()
    
    lazy var spacePhotoTitle : String = { return "Añadir espacio de fotografías"}()
    lazy var photoUploadAlert : String = { return "Por favor, sube al menos una foto."}()
    lazy var spcHighlgt : String = { return "Entrar en el espacio más destacado"}()
    lazy var spcPhtAlert : String = { return "¿Está seguro que desea eliminar esta foto? Es una agradable!"}()
    
    lazy var spcStyleDesc : String = { return "El estilo de su espacio puede ser descrito como"}()
    lazy var spcFeatDesc : String = { return "¿Qué características especiales tiene su espacio?"}()
    lazy var spcRulesDesc : String = { return "Establecer las reglas Espacio"}()
    
    lazy var travelTitle : String = { return "Los viajeros decirle acerca de su espacio"}()
    lazy var travelDesc1 : String = { return "Cada espacio en"}()
    lazy var travelDesc2 : String = { return "es único. Resaltar lo que hace que su inclusión en la lista de bienvenida para que se destaca a los clientes que desean permanecer en su área"}()
    lazy var lisNameTit : String = { return "Nombre de venta"}()
    lazy var sumTit : String = { return "Resumen"}()
    lazy var charsLeft : String = { return "quedan caracteres"}()
    lazy var charLeft : String = { return "personaje izquierda"}()
    lazy var secTit: String = {return "Segura"}()
    lazy var signInWith : String =  { return "Inicia sesión con"}()
    
    //Delete account
    lazy var accDelete : String = { return "Borrar cuenta"}()
    
    lazy var confirm : String = { return "Confirmar"}()
    lazy var close : String = { return "Cerca"}()
    lazy var confrimationDlt : String = { return "Todos sus viajes, reservas, historial de transacciones, lista se eliminarán de forma permanente"}()
    
    lazy var deleteUser1 : String = { return "La usuario que buscas se elimina"}()
    lazy var deleteUser2 : String = { return "Se ha eliminado la habitación que buscas."}()
    lazy var deleteUser3 : String = { return "Problema con el sitio web de reservas"}()
    lazy var deleteUser4 : String = { return "Problema de red móvil"}()
    lazy var deleteUser5 : String = { return "El enlace de la aplicación no está disponible"}()
    lazy var deleteUser6 : String = { return "¡Oh, no! Esto es molesto. ¡Disculpe las molestias! Esto podría porque"}()
    lazy var deleteUser7 : String = { return "Para obtener más información, póngase en contacto con el administrador"}()
    
    lazy var confirmationText : String = { return "Todos sus viajes, reservas, historial de transacciones, lista se eliminarán de forma permanente"}()
    lazy var payoutContent : String = { return "Su pago o reembolso pendiente aún no se ha cobrado. ¿Está seguro de que desea eliminar esta cuenta?"}()

    lazy var DeltedTxt : String = { return "Borrar"}()
    lazy var DeleteConfirmation : String = { return "Cuenta eliminada con éxito"}()
    lazy var add_Title_Describtion : String = { return "Makent se basa en las relaciones. Ayuda a otras personas a conocerte. /n Cuéntales sobre las cosas que te gustan: comparte tus destinos de viaje favoritos, libros, películas, espectáculos, música, comida. /n Cuéntales cómo es tenerte como huésped o anfitrión: ¿Cuál es tu estilo de viajar? ¿De alojamiento Makent? /n Cuéntales sobre ti: ¿Tienes un lema de vida?"}()

    lazy var Tax : String = { return "Impuesto"}()
    lazy var addPhoto : String = { return "Agregar fotos"}()
    
    lazy var aboutFirstPt : String = { return "Makent se basa en las relaciones. Ayuda a otras personas a conocerte."}()
    lazy var aboutSecondPt : String = { return "Tell them about the things you like: Share your favorite travel destinations, books, movies, shows, music, food."}()
    lazy var aboutThirdPt :  String = { return "Cuéntales cómo es tenerte como invitado o anfitrión: ¿Cuál es tu estilo de viajar? ¿De alojamiento Makent?"}()
    lazy var aboutFourthPt : String = { return "Cuéntales sobre ti: ¿Tienes un lema de vida?"}()
    lazy var delete_acc_content : String = { return "Todos sus viajes, reservas, historial de transacciones, lista se eliminarán de forma permanente"}()
}

