FactoryGirl.define do
  # TODO awful. fix at some point
  factory :bike do
    #brand { Brand.first || association(:brand) }
      ##association :brand, name: brand_name
      #brand { build(:brand, name: brand_name) }
    #else
      #brand
    #end
      #brand { build(:brand, name: brand_name) }
      #model { build(:model, brand_name: brand.name) }
      #model { build(:model, name: model_name, brand_name: brand.name) }
    trait :with_names do
      transient do
        model_name nil
        brand_name nil
      end
      brand { build(:brand, name: brand_name) }
      model { build(:model, name: model_name, brand_name: brand.name) }
    end
    frame_only true
    size 'L'
    price 1250

    post

    #association :model, name: 'Foxy', brand_name: 'Mondraker'# brand: {Brand.first }
    #model { build(:model, name: 'Foxy', brand_name: brand.name) } # unless model
    #brand model.brand
    # if here to allow skipping this
    after :build do |bike| 
      #model = build(:model, name: 'Foxy')
      #model.brand = bike.brand
      #model.save
      #bike.model = model
    end

    factory :gambler do
    end
  end


  factory :brand do
    sequence(:name) { |n| "Brand#{n}" }
    confirmation_status 1
  end
  
  factory :model do
    transient do
      brand_name nil
    end
    #transient do
      #brand_name false
    #end
    #brand { Brand.find_or_create_by!(name: brand_name) }
    sequence(:name) { |n| "Model#{n}" }
    confirmation_status 1
    after :build do |model, evaluator|
      model.brand = Brand.find_by(name: evaluator.brand_name) || 
                    build(:brand, name: evaluator.brand_name)
      #model.save!
    end
    #association :brand, name: (brand_name if brand_name)
  end

  factory :post do
    title "USADO (REBAJADO)CUADRO MONDRAKER FOXY RR+TALAS 36 RC2"
    uri "http://www.foromtb.com/threads/rebajado-cuadro-mondraker-foxy-rr-talas-36-rc2.1205912/"
    thread_id 1205912
    images []
    last_message_at { Time.parse("2015-11-12 16:32:03 +1") }
    posted_at { Time.parse("2015-11-10 12:36:23 +1") }
    description "<blockquote class=\"messageText SelectQuoteContainer ugc baseHtml\">\n\t\t\t\t\t\n\t\t\t\t\tMuy buenas....<br>\nSe vende cuadro mondraker foxy RR '12 talla L ( creo que era de 1'75 a 1'85 aprox), eje pasante de 135×12, con cierre de tija, juego de dirección, amortiguador fox RP23 200×57 factory kashima adaptative logic (con guardabarros protector de carbono), potencia on off stoic de 50 (2013), manillar mondraker custom design de 72 (original de la bici) y horquilla fox Talas 36 160 / 120 RC2 fit factory Kashima con eje de 20 (2013).<br>\nQue decir de esta estupenda bici con el fantástico sistema zero. Ideal para montaje enduro light. Sube y pedalea muy bien y baja estupendamente.<br>\nPrecio de este kit... 1250 €<br>\nSe encuentra en la zona de Valencia. Mejor ver para apreciar el estado del kit, con las marcas tipicas del uso. Pongo una foto de la bici entera para que os hagais una idea. Se podrian incluir las ruedas acordando precio. Como información adicional decir que el cuadro es para llevar rodamientos enrroscados al cuadro y desviador delantero direct mount. Tubo vertical 470 y tubo horizontal 605.<br>\nCualquier duda, o consulta ya sabeis...  saludos\n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_164913-jpg.3999201/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114603-0dd529c9a9f276d5a54cda4d8164e5a9.jpg\" alt=\"IMG_20150104_164913.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_164946-jpg.3999203/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114605-1f5c3e9394058893e132e26f68fb7961.jpg\" alt=\"IMG_20150104_164946.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165033-jpg.3999205/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114607-92a0b1e9334ea7c6f3c06222e9878d1d.jpg\" alt=\"IMG_20150104_165033.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165102-jpg.3999208/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114610-958d93209946d7ee01a102e879933eaa.jpg\" alt=\"IMG_20150104_165102.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165203-jpg.3999211/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114613-ad67bd6affd0a019574388419bbc25b2.jpg\" alt=\"IMG_20150104_165203.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165240-jpg.3999213/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114615-633ac1006938c3ad5dbf0300e73666db.jpg\" alt=\"IMG_20150104_165240.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165310-jpg.3999214/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114616-c67b97a58babc6f1fa06c7662acf47ee.jpg\" alt=\"IMG_20150104_165310.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_165353-jpg.3999216/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114618-acebfcacd19a799a12a513a28241a254.jpg\" alt=\"IMG_20150104_165353.jpg\" class=\"bbCodeImage\"></a>\n\t\n \n\n\t<a href=\"http://www.foromtb.com/attachments/img_20150104_164817-jpg.3999189/\" target=\"_blank\"><img src=\"storage/data/attachments/3114/3114591-ae2ae2f319c650c37271f650cceebc8d.jpg\" alt=\"IMG_20150104_164817.jpg\" class=\"bbCodeImage\"></a><br><div align=\"right\">\n<!-- COMIENZO del código HTML de zanox-affiliate -->\n<!-- ( El código HTML no debe cambiarse en pro de una funcionalidad correcta. ) -->\n<a href=\"http://ad.zanox.com/ppc/?29174566C750957508T\"><img src=\"http://ad.zanox.com/ppv/?29174566C750957508\" align=\"bottom\" border=\"0\" hspace=\"1\" alt=\"300x250-_foromtb_\"></a>\n<!--FIN del código HTML de zanox-affiliate -->\n</div>\n\t\t\t\t\t<div class=\"messageTextEndMarker\"> </div>\n\t\t\t\t</blockquote>" 
  end
end

