//
//  BeverageModel.swift
//  LevelMax
//
//  Created by hanseoyoung on 8/10/24.
//

import SwiftUI
import Combine

class SharedDataModel: ObservableObject {
    @Published var ingestedCaffeine: Int = 0
    @Published var selectedWeek: Int = 0
}

enum BeverageCategory: String, CaseIterable {
    case coffee = "Coffee"
    case decaff = "Decaffein"
    case tea = "Tea"
    case nonCoffee = "Non coffee"
    case chocolate = "Chocolate"
    case desert = "Dessert"
    case carbonated = "Soft drink"
    case refresh = "Refresher"
    case etcBev = "etc."

}

struct Beverage: Identifiable {
    let id = UUID()
    let name: String
    let caffeineContent: Int
    let imageURL: URL
    let bevType: BeverageCategory
}

let beverages: [Beverage] = [
    Beverage(name: "에스프레소 콘 파나", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[30]_20150813221811035.jpg")!, bevType: .coffee),
    Beverage(name: "나이트로 바닐라 크림", caffeineContent: 232, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/09/[9200000002487]_20190919181354811.jpg")!, bevType: .coffee),
    Beverage(name: "에스프레소 마키아또", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[25]_20150813221101511.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 카페 아메리카노", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110563]_20150813222100205.jpg")!, bevType: .coffee),
    Beverage(name: "카페 아메리카노", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[94]_20150813222021797.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 카라멜 마키아또", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110582]_20150803101947329.jpg")!, bevType: .coffee),
    Beverage(name: "나이트로 콜드 브루", caffeineContent: 245, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2017/03/[9200000000479]_20170328134443491.jpg")!, bevType: .coffee),
    Beverage(name: "카라멜 마키아또", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[126197]_20150813215717145.jpg")!, bevType: .coffee),
    Beverage(name: "돌체 콜드 브루", caffeineContent: 155, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/04/[9200000002081]_20190409153909754.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 카푸치노", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110601]_20150803101741931.jpg")!, bevType: .coffee),
    Beverage(name: "바닐라 크림 콜드 브루", caffeineContent: 155, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2017/04/[9200000000487]_20170405152830656.jpg")!, bevType: .coffee),
    Beverage(name: "카푸치노", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[38]_20150821164230205.jpg")!, bevType: .coffee),
    Beverage(name: "제주 비자림 콜드 브루", caffeineContent: 305, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2020/02/[9200000002672]_20200220135658603.jpg")!, bevType: .coffee),
    Beverage(name: "라벤더 카페 브레베", caffeineContent: 105, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/12/[9200000000432]_20161213140957549.jpg")!, bevType: .coffee),
    Beverage(name: "콜드 브루", caffeineContent: 155, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/04/[9200000000038]_20160408135802583.jpg")!, bevType: .coffee),
    Beverage(name: "콜드 브루", caffeineContent: 360, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/04/[9200000000038]_20160408135802583.jpg")!, bevType: .coffee),
    Beverage(name: "콜드 브루 몰트", caffeineContent: 190, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/07/[9200000001636]_20180726125512959.jpg")!, bevType: .coffee),
    Beverage(name: "콜드 브루 플로트", caffeineContent: 190, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/07/[9200000001635]_20180726125607716.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 커피", caffeineContent: 140, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[106509]_20150724164325806.jpg")!, bevType: .coffee),
    Beverage(name: "오늘의 커피", caffeineContent: 260, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[2]_20150724164438965.jpg")!, bevType: .coffee),
    Beverage(name: "스타벅스 돌체 라떼", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[128692]_20150723020548334.jpg")!, bevType: .coffee),
    Beverage(name: "블론드 바닐라 더블 샷 마키아또", caffeineContent: 170, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2020/04/[9200000002950]_20200416142151248.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 라벤더 카페 브레베", caffeineContent: 105, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/12/[9200000000433]_20161213162207565.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 블론드 바닐라 더블 샷 마키아또", caffeineContent: 170, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2020/04/[9200000002953]_20200416142415416.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 스타벅스 돌체 라떼", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[128695]_20150803100201827.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 카페 라떼", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110569]_20150813221315558.jpg")!, bevType: .coffee),
    Beverage(name: "카페 라떼", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[41]_20150813221357067.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 카페 모카", caffeineContent: 95, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110566]_20150813221545188.jpg")!, bevType: .coffee),
    Beverage(name: "아이스 화이트 초콜릿 모카", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110572]_20150803102719365.jpg")!, bevType: .coffee),
    Beverage(name: "카페 모카", caffeineContent: 95, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[46]_20150803105114955.jpg")!, bevType: .coffee),
    Beverage(name: "화이트 초콜릿 모카", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[128192]_20150803101501786.jpg")!, bevType: .coffee),
    Beverage(name: "바닐라 스타벅스 더블 샷", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/10/[110612]_20181022143635372.jpg")!, bevType: .coffee),
    Beverage(name: "에스프레소", caffeineContent: 75, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[20]_20150813221922860.jpg")!, bevType: .coffee),
    Beverage(name: "커피 스타벅스 더블 샷", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[110611]_20150813220251546.jpg")!, bevType: .coffee),
    Beverage(name: "클래식 아포가토", caffeineContent: 210, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/07/[9200000001631]_20180726125701682.jpg")!, bevType: .coffee),
    Beverage(name: "헤이즐넛 스타벅스 더블 샷", caffeineContent: 150, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/10/[110614]_20181022143713148.jpg")!, bevType: .coffee),
    Beverage(name: "에스프레소 프라푸치노", caffeineContent: 120, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[168007]_20150813222212580.jpg")!, bevType: .coffee),
    Beverage(name: "자바 칩 프라푸치노", caffeineContent: 100, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[168016]_20150813231001795.jpg")!, bevType: .tea),
    Beverage(name: "카라멜 프라푸치노", caffeineContent: 85, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[168010]_20150813220355957.jpg")!, bevType: .coffee),
    Beverage(name: "제주 까망 크림 프라푸치노", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/02/[9200000002088]_20190221165617615.jpg")!, bevType: .tea),
    Beverage(name: "제주 쑥떡 크림 프라푸치노", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/02/[9200000002090]_20190221165833026.jpg")!, bevType: .tea),
    Beverage(name: "초콜릿 크림 칩 프라푸치노", caffeineContent: 10, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[168066]_20150806163214398.jpg")!, bevType: .tea),
    Beverage(name: "화이트 타이거 프라푸치노", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/07/[9200000002403]_20190711125729583.jpg")!, bevType: .tea),
    Beverage(name: "민트 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000056]_20160905095218258.jpg")!, bevType: .tea),
    Beverage(name: "아이스 민트 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000059]_20160905100053415.jpg")!, bevType: .tea),
    Beverage(name: "아이스 유스베리 티", caffeineContent: 20, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[9200000000229]_20160905094710340.jpg")!, bevType: .tea),
    Beverage(name: "아이스 유자 민트 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/10/[9200000002574]_20191024172411435.jpg")!, bevType: .tea),
    Beverage(name: "아이스 잉글리쉬 브렉퍼스트 티", caffeineContent: 40, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000019]_20160905100755199.jpg")!, bevType: .tea),
    Beverage(name: "아이스 캐모마일 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000079]_20160905101225299.jpg")!, bevType: .tea),
    Beverage(name: "아이스 히비스커스 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000069]_20160905101347323.jpg")!, bevType: .tea),
    Beverage(name: "유스베리 티", caffeineContent: 20, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[9200000000226]_20160902191950457.jpg")!, bevType: .tea),
    Beverage(name: "유자 민트 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/10/[9200000002572]_20191024172324356.jpg")!, bevType: .tea),
    Beverage(name: "잉글리쉬 브렉퍼스트 티", caffeineContent: 70, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000016]_20160905101803555.jpg")!, bevType: .tea),
    Beverage(name: "자몽 허니 블랙 티", caffeineContent: 70, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/08/[9200000000187]_20160831101015864.jpg")!, bevType: .tea),
    Beverage(name: "캐모마일 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000076]_20160905102720278.jpg")!, bevType: .tea),
    Beverage(name: "히비스커스 블렌드 티", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[4004000000066]_20160905103109675.jpg")!, bevType: .tea),
    Beverage(name: "아이스 자몽 허니 블랙 티", caffeineContent: 30, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/08/[9200000000190]_20160831101044745.jpg")!, bevType: .tea),
    Beverage(name: "아이스 차이 티 라떼", caffeineContent: 70, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[135612]_20150813231332047.jpg")!, bevType: .tea),
    Beverage(name: "차이 티 라떼", caffeineContent: 70, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2016/09/[135608]_20160905102333344.jpg")!, bevType: .tea),
    Beverage(name: "시그니처 핫 초콜릿", caffeineContent: 15, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/08/[72]_20150813231821724.jpg")!, bevType: .nonCoffee),
    Beverage(name: "아이스 시그니처 초콜릿", caffeineContent: 15, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[110621]_20150723005650081.jpg")!, bevType: .nonCoffee),
    Beverage(name: "플러피 판다 핫 초콜릿", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2019/12/[9200000002594]_20191212184806553.jpg")!, bevType: .nonCoffee),
    Beverage(name: "스팀 우유", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[17]_20150723005119481.jpg")!, bevType: .etcBev),
    Beverage(name: "아이스 제주 까망 라떼", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/04/[9200000001302]_20180418152834948.jpg")!, bevType: .coffee),
    Beverage(name: "우유", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2015/07/[18]_20150723002143131.jpg")!, bevType: .etcBev),
    Beverage(name: "제주 까망 라떼", caffeineContent: 0, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2018/04/[9200000001301]_20180418152720660.jpg")!, bevType: .etcBev),
    Beverage(name: "가나 밀크초콜릿", caffeineContent: 14, imageURL: URL(string: "https://sitem.ssgcdn.com/02/67/04/item/1000400046702_i1_750.jpg")!, bevType: .chocolate),
    Beverage(name: "노브랜드 미니 밀크초콜릿", caffeineContent: 28, imageURL: URL(string: "https://sitem.ssgcdn.com/51/87/12/item/1000015128751_i1_750.jpg")!, bevType: .chocolate),
    Beverage(name: "밀카 알프스밀크", caffeineContent: 22, imageURL: URL(string: "https://img.danawa.com/prod_img/500000/408/846/img/8846408_1.jpg?_v=20191223094223")!, bevType: .chocolate),
    Beverage(name: "스타벅스 밀크 초콜릿", caffeineContent: 10, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2021/04/[5650003322]_20210421154642682.jpg")!, bevType: .chocolate),
    Beverage(name: "토블론 스위스 밀크 초콜릿", caffeineContent: 16, imageURL: URL(string: "https://thumbnail.10x10.co.kr/webimage/image/basic600/146/B001461309.jpg?cmd=thumb&w=400&h=400&fit=true&ws=false")!, bevType: .chocolate),
    Beverage(name: "허쉬 밀크초콜릿", caffeineContent: 35, imageURL: URL(string: "https://img.danawa.com/prod_img/500000/295/463/img/4463295_1.jpg?_v=20180517174543")!, bevType: .chocolate),
    Beverage(name: "노브랜드 다크초콜릿", caffeineContent: 11, imageURL: URL(string: "https://sitem.ssgcdn.com/06/17/50/item/1000532501706_i1_750.jpg")!, bevType: .chocolate),
    Beverage(name: "마켓오초콜릿 오리지널", caffeineContent: 9, imageURL: URL(string: "https://static.megamart.com/product/image/1199/11997894/11997894_1_960.jpg")!, bevType: .chocolate),
    Beverage(name: "약콩초콜릿", caffeineContent: 12, imageURL: URL(string: "https://cdn.011st.com/11dims/resize/600x600/quality/75/11src/product/1888087934/B.jpg?998000000")!, bevType: .chocolate),
    Beverage(name: "토블론 스위스 다크 초콜릿", caffeineContent: 20, imageURL: URL(string: "https://thumbnail.10x10.co.kr/webimage/image/basic600/146/B001460497.jpg?cmd=thumb&w=400&h=400&fit=true&ws=false")!, bevType: .chocolate),
    Beverage(name: "코카콜라", caffeineContent: 34, imageURL: URL(string: "https://images.emarteveryday.co.kr/images/app/webapps/evd_web2/share/SKU/mall/04/30/8801094013004_1.png")!, bevType: .carbonated),
    Beverage(name: "펩시콜라", caffeineContent: 32, imageURL: URL(string: "https://img.danawa.com/prod_img/500000/722/205/img/2205722_1.jpg?_v=20180115153627")!, bevType: .carbonated),
    Beverage(name: "딸기 아사이 레모네이드 스타벅스 리프레셔", caffeineContent: 30, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2022/08/[9200000003763]_20220803131322900.jpg")!, bevType: .refresh),
    Beverage(name: "디카페인 아메리카노", caffeineContent: 10, imageURL: URL(string: "https://image.istarbucks.co.kr/upload/store/skuimg/2021/04/[110563]_20210426095937947.jpg")!, bevType: .decaff)
]
