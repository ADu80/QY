import Promise from 'bluebird';

const API_URL='http://localhost:8038/api'


export function fetchData(url) {
    return new Promise((resolve, reject) => {
        $.get(url)
            .done((res) => {
                resolve(res);
            })
            .error((err) => {
                reject(err);
            })
    })
}

export function postData(url, data) {
    return new Promise((resolve, reject) => {
        $.post(url, { dataType: 'json', data: data })
            .done((res) => {
                resolve(res);
            })
            .error((err) => {
                reject(err);
            })
    })
}
