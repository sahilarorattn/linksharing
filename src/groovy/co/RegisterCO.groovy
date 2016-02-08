package co

import com.intelligrape.linksharing.domain.User
import grails.validation.Validateable
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.commons.CommonsMultipartFile

/**
 * Created by ttnd on 19/1/16.
 */
@Validateable
class RegisterCO {
    String email
    String password
    String cnfpassword
    String userName
    String firstName
    String lastName
    MultipartFile photo

    static constraints ={
        email (size:5..15,email: true, nullable: false, blank: false)
        userName size:5..15, nullable: false, blank: false
        password  size:5..15, nullable: false, blank: false
        firstName size:5..15, nullable: false, blank: false
        lastName size:5..15, nullable: false, blank: false

        password validator:{password1, obj ->
            if(password1?.equals(obj.cnfpassword)){
                return true
            }
            else{
                return false
            }
        }
    }


    void upload(String fileLocation, User user, CommonsMultipartFile photo) {
        String[] type = photo.fileItem.name.split("\\.")
        File fi = new File(fileLocation,"user_image_${user.id}"+(type.length>1?".${type[type.length-1]}":""))
        fi.setBytes(photo.bytes)
        println fi.absolutePath
        //response.setContentType(f.contentType)
        //response.addHeader("Content-disposition", "attachment; filename="+f.fileItem.name)
        //response.outputStream << f.inputStream.bytes
    }

}
